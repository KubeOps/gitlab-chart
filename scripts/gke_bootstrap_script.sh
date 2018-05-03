#!/bin/bash
# This bash script shall create a GKE cluster, an external IP, setup kubectl to
# connect to the cluster without changing the home kube config and finally install
# helm with the appropriate service account if RBAC is enabled.

set -e


function loadvars() {
  REGION="${REGION:-us-central1}"
  ZONE_EXTENSION="${ZONE_EXTENSION:-b}"
  ZONE="${REGION}-${ZONE_EXTENSION}"
  CLUSTER_NAME="${CLUSTER_NAME:-gitlab-cluster}"
  MACHINE_TYPE="${MACHINE_TYPE:-n1-standard-4}"
  RBAC_ENABLED="${RBAC_ENABLED:-true}"
  NUM_NODES="${NUM_NODES:-2}"
  PREEMPTIBLE="${PREEMPTIBLE:-false}"
  EXTRA_CREATE_ARGS="${EXTRA_CREATE_ARGS-""}"
  USE_STATIC_IP="${USE_STATIC_IP:-false}"
  external_ip_name="${CLUSTER_NAME}-external-ip"
}


function loadcommon() {
    DIR=$(dirname "$(readlink -f "$0")")
    source $DIR/common.sh
}


function bootstrap(){
  set -e
  validate_required_tools

  # Use the default cluster version for the specified zone if not provided
  CLUSTER_VERSION=${CLUSTER_VERSION:-$(get_default_cluster_version "$ZONE")}

  if $PREEMPTIBLE; then
    EXTRA_CREATE_ARGS="$EXTRA_CREATE_ARGS --preemptible"
  fi

  print "\nStarting Cluster Provisioning"
  gcloud container clusters create $CLUSTER_NAME \
    --zone $ZONE \
    --cluster-version $CLUSTER_VERSION \
    --machine-type $MACHINE_TYPE \
    --scopes $(echo -e "https://www.googleapis.com/auth/ndev.clouddns.readwrite,
             https://www.googleapis.com/auth/compute,
             https://www.googleapis.com/auth/devstorage.read_only,
	     https://www.googleapis.com/auth/logging.write,
	     https://www.googleapis.com/auth/monitoring,
	     https://www.googleapis.com/auth/servicecontrol,
	     https://www.googleapis.com/auth/service.management.readonly,
	     https://www.googleapis.com/auth/trace.append" | tr -d '[:space:]') \
    --node-version $CLUSTER_VERSION \
    --num-nodes $NUM_NODES  \
    --project $PROJECT $EXTRA_CREATE_ARGS

  if [ "${USE_STATIC_IP}" = "true" ] ; then
    print "Creating external IP address"
    gcloud compute addresses create $external_ip_name \
      --region $REGION \
      --project $PROJECT
    address=$(gcloud compute addresses describe $external_ip_name \
	        --region $REGION \
		--project $PROJECT \
		--format='value(address)')

    print "Successfully provisioned external IP address $address"
    echo "You need to add an A record to the DNS name to point to this address $address"
    echo "See https://gitlab.com/charts/gitlab/blob/master/doc/cloud/gke.md#dns-entry"
  fi

  print "Adding cluster-credentials to subfolder"
  mkdir -p cluster-credentials/.kube
  touch cluster-credentials/.kube/config

  print "Setting kube conf path to config in subfolder cluster-credentials"
  export KUBECONFIG=$(pwd)/cluster-credentials/.kube/config

  gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT

  if [ "${RBAC_ENABLED}" = "true" ]; then
    print "Creating roles for RBAC Helm"
    status_code=$(curl -L -w '%{http_code}' \
                       -o rbac-config.yaml \
		       -s "https://gitlab.com/charts/gitlab/raw/master/doc/helm/examples/rbac-config.yaml")
    if [ "$status_code" != 200 ]; then
      errprint "Failed to download rbac-config.yaml, status code: $status_code"
      exit 1
    fi

    password=$(cluster_admin_password_gke);

    kubectl --username=admin --password=$password create -f rbac-config.yaml
  fi

  print "Installing helm..."
  helm init --wait --service-account tiller
  helm repo update

  if [ "${USE_STATIC_IP}" = "false" ]; then
    helm install --name dns --namespace kube-system stable/external-dns \
      --set provider=google \
      --set google.project=$PROJECT \
      --set rbac.create=true \
      --set policy=sync
  fi
}


function cleanup_gke_resources(){
  validate_required_tools
  print "Deleting cluster $CLUSTER_NAME"
  gcloud container clusters delete -q $CLUSTER_NAME --zone $ZONE --project $PROJECT

  if [ "${USE_STATIC_IP}" = "true" ]; then
    print "Deleting external IP address $external_ip_name"
    gcloud compute addresses delete -q $external_ip_name --region $REGION --project $PROJECT
  fi

  warnprint "Warning: Disks, load balancers, DNS records, and other cloud resources created during
    the helm deployment are not deleted, please delete them manually from the gcp console."
}


function print() {
  echo -e "\n\e[1;32m"$1"\e[00m"
}


function warnprint() {
  echo -e "\e[1;33m"$1"\e[00m"
}


function errprint() {
  echo -e "\e[1;31m"$1"\e[00m"
}


function main() {
  loadvars
  loadcommon

  if [ -z "$1" ]; then
    echo "You need to pass up or down"
  fi

  DIR=$(dirname "$(readlink -f "$0")")

  case $1 in
    up)
      bootstrap
      ;;
    down)
      cleanup_gke_resources
      ;;
    chaos)
      $DIR/kube-monkey.sh
      ;;
    *)
      echo "Unknown command $1"
      exit 1
  esac
}

main "$1"

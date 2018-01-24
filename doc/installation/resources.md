# Preparing GKE resources

To operate effectively, you will need to create a few resources before configuration and deployment of this chart.

You'll need a domain on which to host the services, which we will not cover here. You will need a [static IP](#static-ip) for the Ingress, so that you can create a [DNS entry](#dns-entry) for your hostnames.

## Bootstrap

Run `scripts/gke_bootstrap_script.sh` to create a new GKE cluster, setup kubectl to connect to it and have helm installed and initialized. Skip next section if you used the script.

## Static IP

External IP for ingress is required so that your cluster can be reachable. The external IP needs to be regional and in the same region as the cluster itself

> A global IP or an IP outside the region will not work.

To create a static IP run the following gcloud command:

`gcloud compute addresses create $EXTERNAL_IP_NAME --region $REGION

To get the address of the newly created IP run the following gcloud command:

`gcloud compute addresses describe $EXTERNAL_IP_NAME --region $REGION --format='value(address)'`

We will use this IP to bind with a DNS name in the next section.

## DNS Entry

In order to use ingress host rules to access various components of gitlab we will need a public domain with an `A record` entry pointing to the IP we just created.

Follow [This](https://cloud.google.com/dns/quickstart) to create the DNS entry.


Once all resources have been generated and recorded, you can proceed to generating [secrets](README.md#secrets).

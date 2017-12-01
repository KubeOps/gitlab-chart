FROM alpine:latest
MAINTAINER GitLab Build Team

# ENV GCLOUD_SDK_VERSION=181.0.0
# ENV GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz

ENV TF_VERSION=0.11.1
ENV TF_URL=https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip

ENV HELM_VERSION=2.7.2
ENV HELM_URL=https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz

# kubectl (possibly in gcloud?)
ENV KUBECTL_VERSION=1.8.4
ENV KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

# Install dependencies
RUN apk --no-cache add -U openssl curl tar gzip bash ca-certificates git python2 \
  && mkdir /opt

# Install gcloud-sdk
# RUN cd /opt \
#     && wget -q -O - $GCLOUD_SDK_URL | tar zxf - \
#     && /opt/google-cloud-sdk/install.sh --quiet \
#       --usage-reporting=false \
#       --path-update=true \
#       --bash-completion=false \
#       --override-components core kubectl gsutil \
#     && ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin \
#     && ln -s /opt/google-cloud-sdk/bin/gsutil /usr/local/bin \
#     && ln -s /opt/google-cloud-sdk/bin/kubectl /usr/local/bin \
#     && rm -rf /opt/google-gcloud-sdk/.install/.backup \
#     && /opt/google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true \
#     && /opt/google-cloud-sdk/bin/gcloud version

# Install kubectl
RUN curl -L -o /usr/local/bin/kubectl ${KUBECTL_URL} \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client

# Install Terraform
RUN curl -LJO ${TF_URL} \
    && unzip terraform*.zip -d /usr/bin  && chmod +x /usr/bin/terraform \
    && rm terraform*.zip \
    && terraform version

# Install Helm
RUN wget -q -O - ${HELM_URL} | tar zxf - \
    && mv linux-amd64/helm /usr/bin/ \
    && chmod +x /usr/bin/helm \
    && helm version --client

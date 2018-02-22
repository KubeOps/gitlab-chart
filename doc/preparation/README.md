# Pre-install preparations

This document covers our weekly demos preparation steps but can also be useful to anyone who tries to install using the charts before going through [installation](../installation/README.md).
The demoer need to go throw this document before the demo.

## GKE setup

### Gcloud user

Make sure to have a gcloud user with permissions to access `cloud-native` project. All the [installation procedures](../installation/README.md) will need to be done
in this project.

### gcloud installation

You will need to have [gcloud](https://cloud.google.com/sdk/gcloud/) tool installed on your system.

#### Install gcloud:

```
mkdir gcloud-build && cd gcloud-build;
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-189.0.0-linux-x86_64.tar.gz;
tar -xzf google-cloud-sdk-189.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
source google-cloud-sdk/path.bash.inc && echo "source google-cloud-sdk/path.bash.inc" >> $HOME/.profile
```

#### Initialize gcloud

Run `./google-cloud-sdk/bin/gcloud init` and interactively go through authentication and initialization of gcloud.

### Domain name

During the demo you will need a valid domain name that will resolve to our cluster load balancer through a wild card entry.
Make sure to have one of the Domain names ready for the demo either by creating a new one or by using an existing one.

We usually use `cloud-native-win` or `k8s-ftw`

## Kube monkey

Follow our [kube monkey](../kube-monkey/README.md) guide for running kube monkey, this is usually done after the demo.
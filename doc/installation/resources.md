# Preparing Resources

To operate effectively, you will need to create a few resources before configuration and deployment of this chart.

You'll need a domain on which to host the services, which we will not cover here. You will need a [static IP](#static-ip) for the Ingress, so that you can create a [DNS entry](#dns-entry) for your hostnames.


### Install with defaults
Run `scripts/gke_bootstrap_script.sh` to create a new GKE cluster, setup kubectl to connect to it and have helm installed and initialized. Skip next sections if you used the script.


## Static IP
You'll need an external IP for ingress to use in order for your cluster to be reachable.
To create a static IP run the following gcloud command:

`gcloud compute addresses create <name for the ip> --region <you region>`

To get the address of the newly created IP run the following gcloud command:

`gcloud compute addresses describe <name of the ip> --region <your region> --format='value(address)'`

This Ip shall be pointed to by a DNS name which we will use in ingress hosts to point to the gitlab components. Take note of this IP we will need it later in the configuration phase.

## DNS Entry
In order to use ingress host rules to access various components of gitlab we will need a public domain with an `A record` entry pointing to the IP we just created.

Follow [This](https://cloud.google.com/dns/quickstart) to create the DNS entry.


Once all resources have been generated and recorded, you can proceed to generating [secrets](README.md#secrets).

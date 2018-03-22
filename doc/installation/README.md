# Installing GitLab using Helm

> **Notes**:
* This chart is **alpha**. It should not be used for production deployments.
* There are [known issues and limitations](doc/architecture/alpha.md#known-issues-and-limitations).

Installing GitLab on Kubernetes with the cloud native GitLab Helm chart.

Follow the instructions below to get started.

## 1. Prerequisites

In order to install GitLab in a Kubernetes cluster, there are a few required tools. To get started, [prepare your computer](tools.md).

## 2. Where do you want to install GitLab?

Follow the instructions to connect to the Kubernetes cluster of your choice.

* [Google Kubernetes Engine][]
* Amazon EKS - Documentation to be added.
* Azure Container Service - Documentation to be added.
* Pivotal Container Service - Documentation to be added.
* On-Premises solutions - Documentation to be added.

## 3. Deploy

With the environment setup and configuration generated,
we can proceed to [deployment][].

[Google Kubernetes Engine]: ../cloud/gke.md
[resources]: resources.md
[deployment]: deployment.md

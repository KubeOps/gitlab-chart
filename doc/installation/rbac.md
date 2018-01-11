# Role Based Access Control

Until Kubernetes 1.7, there were no permissions within a cluster. With the launch of 1.7, there is now a role based access control system ([RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)) which determines what services can perform actions within a cluster.

RBAC affects a few different aspects of GitLab:
* [Installation of GitLab using Helm](../helm/README.md#preparing-for-helm-with-rbac)
* [nginx](../charts/nginx/README.md#generate-the-service-account)
* Prometheus monitoring
* GitLab Runner
* [kube-lego](../kube-lego/README.md)

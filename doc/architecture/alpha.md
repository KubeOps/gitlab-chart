# GitLab Cloud Native Chart Alpha

> **Note**: This chart is **alpha**. It should not be used for production deployments.

We have been working hard on the chart and it's underlying containers, and are excited to to reach alpha and share it with the GitLab community.

This effort has required extensive changes across the  product:
* Support for directly uploading to object storage
* No dependency on shared storage
* New containers for each component of GitLab
* New Helm chart

While much of the underlying work has been completed, there are a few changes that will be arriving after alpha has started. This means that there are a few features of GitLab [that may not work as expected](#known-issues-and-limitations).

## Release cadence

In order to maximize our testing opportunity in alpha, the chart and containers will be rebuilt off `master` as changes are merged. This means that fixes and improvements will be available immediately, instead of waiting for a specific release.

Along with the issues and merge requests in this repo, a [changelog](https://gitlab.com/charts/helm.gitlab.io/issues/289) is being made available to more easily follow along with updates throughout the alpha period.

## Kubernetes deployment support

GitLab development and testing is taking place on [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/), however other Kubernetes deployments
should also work. In the event of a specific non-GKE deployment issue, please raise an issue.

We are currently using Kubernetes version 1.8.7 for development. We plan to announce the minimum required Kubernetes version during beta.

## GitLab Enterprise Edition

During alpha, GitLab Enterprise Edition is required while we [bring object storage support to Community Edition](https://gitlab.com/gitlab-org/gitlab-ce/issues/40781). GitLab EE offers same functionality as GitLab CE when no license is supplied.

We will be adding support for GitLab Community Edition before making these charts generally available.

## Technical support during alpha

Technical support is limited during this alpha phase. Due to the in-development nature, standard GitLab support will not be able to assist.

Before opening an issue please review the [known issues and limitations](#known-issues-and-limitations), and [search](https://gitlab.com/charts/helm.gitlab.io/issues) to see if a similar issue already exists.

We greatly appreciate the wider testing of the community during alpha, and encourage [detailed issues to be reported](https://gitlab.com/charts/helm.gitlab.io/issues/new) so we can address them. However we might not be able to provide support for every user request.

We also reserve the right to close issues without providing a reason. Issues can accumulate quickly and we need to spend more time moving the charts forward than doing issue triage.

We welcome any improvements contributed in the form of [Merge Requests](https://gitlab.com/charts/helm.gitlab.io/merge_requests).

## Known issues and limitations

The chart and containers are a work in progress, and not all features are fully functional. Below is a list of the known issues and limitations, although it may not be exhaustive. We recommend also reviewing the [open issues](https://gitlab.com/charts/helm.gitlab.io/issues).

Helm Chart Issues/Limitations:

* No in-cluster HA database https://gitlab.com/charts/helm.gitlab.io/issues/48
* No backup/restore procedure https://gitlab.com/charts/helm.gitlab.io/issues/28
* No update procedures, or support for no-downtime upgrades: https://gitlab.com/charts/helm.gitlab.io/issues/238
* No support for changing/migrating your storage capacity/options after installation https://gitlab.com/charts/helm.gitlab.io/issues/233
* No GitLab Pages support https://gitlab.com/charts/helm.gitlab.io/issues/37
* No Monitoring support https://gitlab.com/charts/helm.gitlab.io/issues/29
* No support for outgoing email https://gitlab.com/charts/helm.gitlab.io/issues/234
* No support for incoming email https://gitlab.com/charts/helm.gitlab.io/issues/235
* No support for customizing GitLab options, e.g. LDAP https://gitlab.com/charts/helm.gitlab.io/issues/236
* No support for advanced workhorse configuration https://gitlab.com/charts/helm.gitlab.io/issues/249
* CI traces are not persisted https://gitlab.com/charts/helm.gitlab.io/issues/245
* No support for scaling unicorn separate from workhorse https://gitlab.com/charts/helm.gitlab.io/issues/61
* GitLab maintenance rake tasks won't work in k8s environments
* No guarantees on safe pod shutdown: https://gitlab.com/charts/helm.gitlab.io/issues/239
* New ssh hostkeys each time the shell container restarts https://gitlab.com/charts/helm.gitlab.io/issues/247

Once GitLab is deployed and running, you might encounter some known issues:

* User uploaded content such as attachments to comments, are not persisted https://gitlab.com/charts/helm.gitlab.io/issues/227
* Navigating to Wiki shows page 500 https://gitlab.com/charts/helm.gitlab.io/issues/226
* Emails are not sent https://gitlab.com/charts/helm.gitlab.io/issues/234
* Pipelines view may generate an HTTP 500 after triggering CI
https://gitlab.com/charts/helm.gitlab.io/issues/291

Features that are currently out of scope:

* Support for MySQL https://gitlab.com/charts/helm.gitlab.io/issues/250
* Mattermost https://gitlab.com/charts/helm.gitlab.io/issues/251

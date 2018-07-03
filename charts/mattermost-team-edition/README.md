# Mattermost Team Edition

[Mattermost](https://mattermost.com/) is a hybrid cloud enterprise messaging workspace that brings your messaging and tools together to get more done, faster.


```bash
$ helm install incubator/mattermost-team-edition
```

## Introduction

This chart creates a [Mattermost Team Edition](https://mattermost.com/) deployment on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mattermost-team-edition
```

The command deploys Mattermost on the Kubernetes cluster in the default configuration. The [configuration](#configuration)
section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Mattermost Team Edition chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `mattermost/mattermost-team-edition`
`image.tag` | container image tag | `5.0.0`
`config.SiteUrl`   | The URL that users will use to access Mattermost. ie `https://mattermost.example.com`|  ``
`config.SiteName`  | Name of service shown in login screens and UI | `Mattermost`
`config.FilesAccessKey` | The AWS Access Key, if you want store the files on S3 | ``
`config.FilesSecretKey` | The AWS Secret Key | ``
`config.FileBucketName` | The S3 bucket name | ``
`config.SMTPHost` | Location of SMTP email server | ``
`config.SMTPPort` | Port of SMTP email server | ``
`config.SMTPUsername` | The username for authenticating to the SMTP server | ``
`config.SMTPPassword` | The password associated with the SMTP username | ``
`config.FeedbackEmail` | Address displayed on email account used when sending notification emails from Mattermost system | ``
`config.FeedbackName` | ame displayed on email account used when sending notification emails from Mattermost system | ``
`ingress.enabled` | if `true`, an ingress is created | `false`
`ingress.hosts` | a list of ingress hosts | `[mattermost.example.com]`
`ingress.tls` | a list of [IngressTLS](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#ingresstls-v1beta1-extensions) items | `[]`


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set image.tag=release-1.2.0 \
    incubator/mattermost-team-edition
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/mattermost-team-edition
```

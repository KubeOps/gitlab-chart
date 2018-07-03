# Using Mattermost Team Edition

This chart is based on [`incubator/mattermost-team-edition`][mm-te-chart] which is currently under review in a PR, and inherits most settings from there.


# Configuration

We will describe all the major sections of the configuration below. When configuring from the parent chart, these values will be as such:

```
mattermost-team-edition:
  config:
    SiteUrl: "https://mattermost.example.com"
    SiteName: "Mattermost"
    FilesAccessKey:
    FilesSecretKey:
    FileBucketName:
    SMTPServer:
    SMTPPort:
    SMTPUsername:
    SMTPPassword:
    FeedbackEmail:
    FeedbackName:
  persistence:
    data:
      enabled: true
      size: 10Gi
      accessMode: ReadWriteOnce
  ingress:
    enabled: false
    path: /
    hosts:
      - mattermost.example.com
    tls:
     secretName: mattermost.example.com-tls
     hosts:
       - mattermost.example.com
  mysql:
    mysqlRootPassword: root_password
    mysqlUser: mmuser
    mysqlPassword: mmpasswd
    mysqlDatabase: mattermost
    repository: mysql
    tag: 5.7
    imagePullPolicy: Always
    persistence:
      enabled: true
      storageClass: ""
      accessMode: ReadWriteOnce
      size: 10Gi
```

## Installation command line options

Table below contains all the possible charts configurations that can be supplied to `helm install` command using the `--set` flags

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


[mm-te-chart]: https://github.com/kubernetes/charts/pull/5987

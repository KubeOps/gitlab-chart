# Using Minio for Object storage

This chartis based on [`stable/minio`][minio-chart] version [`0.4.3`][minio-043], and inherits most settings from there.

The documentation for the upstream chart can be found [here][minio-043].

## Design Choices

Design choices related to the [upstream chart][minio-chart] can be found in their README.

GitLab chose to alter that chart in order to simplify configuration of the secrets, and to remove all use of secrets in environment variables. GitLab added `initContainer`s to control the population of secrets into the `config.json` and a chart-wide `enabled` flag.

This chart makes use of only one secret:
- `minio-credentials`: A secret containing the `accesskey` and `secretkey` values that will be used for authentication to the bucket(s).

# Configuration

We will describe all the major sections of the configuration below. When configuring from the parent chart, these values will be as such:

```
minio:
  enabled:
  init:
  persistence: (upstream)
    volumeName:
  serviceType: (upstream)
  servicePort: (upstream)
  defaultBuckets:
  minioConfig: (upstream)
```

## Enable the sub-chart

They way we've chosen to implement compartmentalized sub-charts includes the ability to disable the components that you may not want in a given deployment. For this reason, the first settings you should decided upon is `enabled:`.

By default, Minio is enabled out of the box. Should you wish to disable it,
set `enabled: false`.

## Configure the initContainer

While rarely altered, the `initContainer` behaviors can be changed via the following items.

```
init:
  image: busybox
  tag: latest
  pullPolicy: IfNotPresent
  script:
```

### initContainer image

The initContainer image settings are just as with a normal image configuration. The defaults are provided [above](#configure-the-initcontainer).

### initContainer script

The initContainer is handed the following items:
- The secret containing authentication items mounted in `/config`, usually `accesskey` and `secretkey`
- The ConfigMap containing the `config.json` template and `configure` containing a script to be executed with `sh`, mounted in `/config`
- An `emptyDir` mounted at `/minio` that will be passed to the daemon's container.

The initContainer is expected to populate `/minio/config.json` with a completed configuration, using `/config/configure` script. When the `minio-config` container has completed that task, the `/minio` directory will be passed to the `minio` container, and used to provide the `config.json` to the [minio][] server.

## Configuring the image

The `image`, `imageTag` and `imagePullPolicy` defaults are [documented upstream][minio-config].

## Persistence

The behaviors for [`persistence`][minio-persistence] are [documented upstream][minio-config]. The key summary is:

> This chart provisions a PersistentVolumeClaim and mounts corresponding persistent volume to default location /export. You'll need physical storage available in the Kubernetes cluster for this to work. If you'd rather use emptyDir, disable PersistentVolumeClaim by: `persitence.enabled: false`

GitLab has added one item:

```
persistence:
  volumeName:
```

### volumeName

When `volumeName` is provided, the `PersistentVolumeClaim` will use the provided `PersistentVolume` by name, in place of creating a `PersistentVolume` dynamically. This overrides the upstream behavior.

## defaultBuckets

`defaultBuckets` provides a mechanism to automatically create buckets on the Minio pod at _installation_. This property contains an array of items, each with up to three properties: `name`, `policy`, and `purge`.

```
defaultBuckets:
  - name: public
    policy: public
    purge: true
  - name: private
  - name: public-read
    policy: download
```

### name

The value of `name` will be the name of the bucket that is created. The provided value should conform to [AWS ucket naming rules][bucket-naming], meaning that it should be compliant with DNS and contain only the characters a-z, 0-9, and – (hyphen) in strings between 3 and 63 characters in length.

The `name` property is _required_ for all entries.

### policy

The value of `policy` controlls the policy of the bucket on Minio.

Possible values are listed below, with description in regards to **anonymous** access:
- `none`: no anonymous access
- `download`: anonymous read-only access
- `upload`: anonymounts write-only access
- `public`: anonymous read/write access

The `policy` property is not required, and default value is `none`.

### purge

The `purge` property is provided as a means to cause any existing bucket to be removed with force, at installation time. This only comes into play when using a pre-existing `PersistentVolume` for the [volumeName](#volumeName) property of [persistence](#persistence). If you make use of a dynamically created `PersistentVolume`, this will have no valuable affect as it only happens at chart installation and there will be no data in the `PersistentVolume` that was just created.

This property is not required, and the default value is `false`. You may specify this property, with a value of `true`, in order to cause a bucket to purged with force: `mc rm -r --force`

## Service Type and Port

These are [documented upstream][minio-config], and the key summary is:
```
## Expose the Minio service to be accessed from outside the cluster (LoadBalancer service).
## or access it from within the cluster (ClusterIP service). Set the service type and the port to serve it.
## ref: http://kubernetes.io/docs/user-guide/services/
##
serviceType: LoadBalancer
servicePort: 9000
```

The chart does not expect to be of the `type: NodePort`, so **do not** set it as such.

## Upstream items

The [upstream documentation][minio-chart] for the following does not need further explanation, and applies completely to this chart.
- `mode`
- `resources`
- `nodeSelector`
- `minioConfig`


[minio]: https://minio.io
[minio-chart]: https://github.com/kubernetes/charts/tree/master/stable/minio
[minio-043]: https://github.com/kubernetes/charts/tree/aaaf98b5d25c26cc2d483925f7256f2ce06be080/stable/minio
[minio-config]: https://github.com/kubernetes/charts/tree/master/stable/minio#configuration
[minio-persistence]: https://github.com/kubernetes/charts/tree/master/stable/minio#persistence
[bucket-naming]: https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html

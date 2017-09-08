# Using the Container Registry

The `registry` sub-chart provides the Registry component to a complete cloud-native
GitLab deployment on Kubernetes. This sub-chart makes use of the upstream [registry][]
[container][docker-distribution-library] containing [Docker Distribution][docker-distribution]. This chart is composed of 3 primary parts: [Service][], [ReplicaSet][], and [ConfigMap][]. An additional optional [Ingress][] has been
provided to allow separation from the global [Ingress](../README.md#ingress) as provided by the parent chart.

All configuration is handled according to the official [Registry configuration documentation][docker-distribution-config-docs]
using environment variables provided to the [ReplicaSet][].

## Design Choices

A Kubernetes `ReplicaSet` was chosen as the deployment method for this chart to
allow for simple scaling of instances.

This chart makes use of only two secrets:
- `certBundle`: A secret that will contain the public certificate bundle to verify
the authentication tokens provided by the associated GitLab instance(s).
- *optional*: The secret which will contain the SSL certificates for the HTTPS
termination by the [Ingress][]. This secrety follows the requirements set forth in
[Kubernetes Ingress's TLS section][kubernetes-ingress]. If you chose to use
the global [Ingress](../README.md#ingress) from the parent chart, this will not
be required at all.

# Configuration

We will describe all the major sections of the configuration below. When configuring from the parent chart, these values will be as such:

```
registry:
  enabled:
  image:
  service:
  registry:
```

If you should chose to deploy this chart as a standalone, remove the top level `registry`.

## Enable the sub-chart

They way we've chosen to implement compartmentalized sub-charts includes the ability to disable the components that you may not want in a given deployment. For this reason, the first settings you should decided upon is `enabled:`.

`enabled` defaults to `true`, so unless you intentionally disable the Registry, you'll have one out of the box.

## Configuring the `image`

This section dictates the settings for the container image used by this sub-chart's [ReplicaSet][]. You can change the included version and `pullPolicy` but it is *not recommended* to alter the `repository`.

Default settings:
- `repository: registry`
- `tag: '2.6'`
- `pullPolicy: 'IfNotPreset'`

## Configuring the `service`

This section controls the name, type, and internal/external ports used by the
[Service][]. It is not recommended to edit these values, and allow them to to be
populated by the [values.yml][].

By default, the [Service][] is configured as:
- `type: ClusterIP` on `0.0.0.0`, restricting access to the interal network of the Kubernetes cluster.
- `internalPort` and `externalPort` are set to the Distribution daemon default of `5000`
- `name:` is set to `registry`. It is *not recommended* to alter `name`

## Configuring the Registry

## Configuring the Ingress (optional)

This section describes configuring the *optional* dedicated [Ingress][]. By default this is disabled, so you'll have to enable it to make use of the following series of settings. Primarily, these settings will be familiar with [Kubernetes Ingress][kubernetes-ingress] documentation, but slightly simplified thanks to [Helm][helm].

#### enabled
Field `enable:`, boolean

This enables or disables this dedicated [Ingress][].

Default `false`, set `true` to enable.

#### hosts

Field `hosts:`, a map of items in the form of `name: fqdn`

This controls the hostnames accepted by the [Ingress][]. Note that we do not make use of any other component fields that could be used when defining an `host:`, as we're only linking to the [Service][] contained in the chart.

#### tls

Field `tls:`, a map of items, per the [Kubernetes Ingress][kubernetes-ingress] documentation.

As the official documentation shows, this field, if populated, should contain a
map including a map of `hosts` by hostname, and a `secretName` which contains
the TLS certificate and key to be used for that hostname. And exmaple is found below
appear as such:

```
tls:
  - hosts:
    - registry.example.local
    secretName: registry-example-tls
```

*Note:* While you may be able to combine `tls` with ACME, it is not tested.

#### annotations

This field is an exact match to the standard `annotations` for [Kubernetes Ingress][kubernetes-ingress]. The default value includes setting of `kubernetes.io/ingress.class: nginx`. If you need to replace this value, or add additional, you may do so.

One example of an additional `annotation` is `kubernetes.io/tls-acme: "true"`
to enable automatic Lets Encrypt as a part of the [Ingress][] in combination with  `kube-lego`.



[registry]: https://hub.docker.com/_/registry/
[docker-distribution]: https://github.com/docker/distribution
[docker-distribution-library]: https://github.com/docker/distribution-library-image
[docker-distribution-config-docs]: https://docs.docker.com/registry/configuration

[Service]: ../../charts/registry/templates/service.yaml
[ReplicaSet]: ../../charts/registry/templates/replicaset.yaml
[ConfigMap]: ../../charts/registry/templates/registry-configmap.yaml
[Ingress]: ../../charts/registry/templates/ingress.yaml
[values.yml]: ../../charts/registry/values.yml

[kubernetes-ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
[helm]: https://helm.sh

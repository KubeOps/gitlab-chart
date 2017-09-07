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

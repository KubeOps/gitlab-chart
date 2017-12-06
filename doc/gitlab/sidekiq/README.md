# Using the GitLab-Sidekiq chart

The `sidekiq` sub-chart provides configurable deployment of Sidekiq workers, explicitly designed to provide separation of queues across multiple `Deployment`s with individual scalability and configuration.

While this chart provides a default `pods:` declaration, if you provide an empty definition, you will have _no_ workers.

## Requirements

This chart depends on access to Redis and PostgreSQL services, either as part of the chart or provided as external services reachable from the Kubernetes cluster this chart is deployed onto.

## Design Choices

This chart creates multiple `Deployment`s and associated `ConfigMap`s. It was decided that it would be clearer to make use of `ConfigMap` behaviours over using `environment` attributes or additional arguments to the `command` for the containers in order to avoid any concerns about command length. This choice results in a large number of `ConfigMap`s, but provides a very clear definition of what each pod should be doing.

# Configuration

The `sidekiq` chart is configured in three parts: chart-wide external services, chart-wide defaults, and per-pod definitions.

## External Services

This chart should be attached to the same Redis and PostgreSQL instances as the

#### Redis

#### PostgreSQL

## Chart-wide defaults

The following values will be used chart-wide, in the event that a value is not presented on a per-pod basis.

#### replicas

The number of `replicas` to use by default per pod definition. The default value is `1`.

#### timeout

The number of seconds _____ . This default value is `4`.

#### concurrency

The number of tasks to process simultaneously. The default value is `25`.

## Per-pod Settings `pods`

The `pods` declaration provides declaration of all attributes for a worker pod. These will be templated to `Deployment`s, with individual `ConfigMap`s for their Sidekiq instances.

You must provide no definitions, relying on the defaults, or provide at least one entry. If you do not, you will have _no_ workers.

#### name

The `name` attribute is used to name the `Deployment` and `ConfigMap` for this pod. It should be kept to short, and should not be duplicated between any two entries.

#### replicas

The number of `replicas` to create for this `Deployment`. If not provided, this will pull from the chart-wide default.

#### timeout

The number of seconds _____ . If not provided, this will pull from the chart-wide default.

#### concurrency

The number of tasks to process simultaneously. If not provided, this will pull from the cahrt-wide default.

#### queues

The `queues` value will be directly templated into the Sidekiq configuration file. As such, you may follow the documentation from Sidekiq for the value of `:queues:`.

In summary, provide an list of queue names to process. Each item in the list may be a queue name (`merge`) or an array of queue name and priority (`[merge, 5]`).

Any queue to which jobs are added but are not represented as a part of at least one pod item _will not b processed_. See [GitLab source for `config/sidekiq_queues.yml`]() for a complete list of all queues.

#### resources

Each pod can present it's own `resources` requirements, which will be added to the `Deployment` created for it, if present. There is no chart-wide default.

These match the kubernetes documentation.

#### nodeSelector

Each pod can be configured with a `nodeSelector` attribute, which will be added to the `Deployment` created for it, if present. There is no chart-wide default.

These definitions match the kubernetes documentation.

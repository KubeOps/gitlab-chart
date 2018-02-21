# Generate configuration

Based on the [example-config.yaml](../example-config.yaml) file, you can generate
your own yaml template.

For this example, we will use domain `example.local`, and expect our hostnames to be: `gitlab.example.local`, `registry.example.local`.

```
cp doc/example-config.yaml configuration.yaml
```

In order to complete the configuration, we will need to prepare a few values:
- Creation of `Secrets` from [secrets documentation](secrets.md)
- [static-ip][] for the `loadBalancerIP`
- [DNS entry][] made for the domain
- `initialRootPassword`, from 1Password or chosen at random

Next, we are replacing the contents of the `configuration.yaml` with valid
information:

Set the following properties in `configuration.yaml`

> *Note:* Find and edit each property. They should already exist, but will need their value set, and may need to be uncommented.

```YAML
global:
  hosts:
    domain: example.local

nginx:
  service:
    loadBalancerIP: <static ip>

kube-lego:
  LEGO_EMAIL: <valid email address>
  # LEGO_URL: <url> should be uncommented if you desire production ready certificates

gitlab:
  migrations:
    initialRootPassword: initialRootPassword
```

If you wish to use your own [custom wildcard certificates](secrets.md#custom-certificates),
edit the config file as follows:

```YAML
nginx:
  ingress:
    acme: false
```

```YAML
kube-lego:
  enabled: false
```

```YAML
global:
  hosts:
    tls:
      secretName: example-local-tls
```

## Sidekiq

By default all of sidekiq queues run in an all-in-one container which is not suitable for production use cases.

Following is an example of splitting queues among several pods that can be suitable for production cases.

```YAML
sidekiq:
  pods:
    - name: workflow
      concurrency: 10
      replicas: 2
      queues:
        - [post_receive, 5]
        - [merge, 5]
        - [new_note, 2]
        - [new_issue, 2]
        - [new_merge_request, 2]
    - name: pipeline
      replicas: 1
      queues:
        - [build, 2]
        - [pipeline, 2]
        - [pipeline_processing, 5]
        - [pipeline_default, 3]
        - [pipeline_cache, 3]
        - [pipeline_hooks, 2]
    - name: glob
      replicas: 1
      queues:
        - [gitlab_shell, 2]
        - [email_receiver, 2]
        - [emails_on_push, 2]
        - [gcp_cluster, 1]
        - [project_migrate_hashed_storage, 1]
        - [storage_migrator, 1]
    - name: ee
      replicas: 1
      queues:
        - [ldap_group_sync, 2]
        - [geo, 1]
        - [repository_update_mirror, 1]
        - [repository_update_remote_mirror, 1]
        - [project_update_repository_storage, 1]
        - [admin_emails, 1]
        - [geo_repository_update, 1]
        - [elastic_batch_project_indexer, 1]
        - [elastic_indexer, 1]
        - [elastic_commit_indexer, 1]
        - [export_csv, 1]
        - [object_storage_upload, 1]
```

`sidekiq.pods[].replicas` controlls the number of replicas of the corresponding pod.
`sidekiq.pods[].concurrency` controlls [sidekiq concurrency](https://github.com/mperham/sidekiq/wiki/Advanced-Options#concurrency).
`sidekiq.pods[].queues` specify the [queues](https://github.com/mperham/sidekiq/wiki/Advanced-Options#queues) that the corresponding sidekiq instance will consume.

> The above example shows all the gitlab queues, you can move them around pods as a part of your tuning.

# Next Steps

Now that the template is generated, we can proceed [to deployment](deployment.md).

[static-ip]: resources.md#static-ip
[DNS entry]: resources.md#dns-entry
[secret-gl-certs]: secrets.md#gitlab-certificates
[secret-reg-certs]: secrets.md#registry-certificates

# Configure this chart with External Databases

This document intends to provide documentation on how to configure this Helm chart with external PostgreSQL and Redis services. For the sake simplicity, we'll make use of the [Omnibus GitLab][] package for Ubuntu. This package provides versions of the services that are guaranteed to be compatible with the charts' services.


## Set up the VM

### Create a Virtual Machine
Craete a VM on your provider of choice, or locally. This was tested with VirtualBox, KVM, and Bhyve.

### Install and Configure Ubuntu Server

Install Ubuntu Server onto the VM that you have created. Ensure that `openssh-server` is installed, and that all packages are up to date. Configure networking and a hostname. Make note of the hostname, and ensure it is both resolvable and reachable from your Kubernetes cluster.

### Install Omnibus GitLab

Follow the installation instructions for [Omnibus GitLab][]. When you perform the package installation, do _not_ provide the `EXTERNAL_URL=` value.

### Configure Omnibus GitLab

Things we want: Redis, PostgreSQL. Things we don't want: everything else.

We'll create a minimal `gitlab.rb` file to be placed at `/etc/gitlab/gitlab.rb`. The contents of that file are below.

```Ruby
## Configure Redis
redis['enable'] = true
# You can bind to a specific address if you desire
redis['bind'] = '0.0.0.0'
# This _must_ be specified
redis['port'] = 6379
# This _must_ be specified
redis['password'] = 'redis-password-goes-here'

## Configure PostgreSQL
postgresql['enable'] = true
# You can ding to a specific address if desired
postgresql['listen_address'] = '0.0.0.0'
# Set to approximately 1/4 of available RAM.
postgresql['shared_buffers'] = "512MB"
# This password is: `echo -n '${password}${username}' | md5sum -`
# The default username is `gitlab`
postgresql['sql_user_password'] = "306a43a5ca6b2d72a89cf54dff4f1367"
# Configure the CIDRs for MD5 authentication
# These should be the smallest possible subnets of your cluster or it's gateway.
# The below example is a section of a LAN with `minikube`.
postgresql['md5_auth_cidr_addresses'] = ['192.168.100.0/12']
# Configure the CIDRs for trusted authentication (passwordless)
postgresql['trust_auth_cidr_addresses'] = ['127.0.0.1/24']

## Don't disable gitlab_rails, because we need the DB init
# gitlab_rails['enable'] = false
# external_url is needed by portions of `gitlab-rails` tasks
# It has no actual value in this configuration.
external_url 'http://not.real'
# We need to prevent the rake_cache_clear however.
gitlab_rails['rake_cache_clear']= false
# Supply the initial initial_root_password
gitlab_rails['initial_root_password']="secure-password"

## Disable everything else
sidekiq['enable'] = false
unicorn['enable'] = false
registry['enable'] = false
gitaly['enable'] = false
gitlab_workhorse['enable'] = false
nginx['enable'] = false
prometheus['enable'] = false
prometheus_monitoring['enable'] = false
```

After creating `gitlab.rb`, we'll reconfigure the package with `gitlab-ctl reconfigure`. Once the task has completed, check the running processes with `gitlab-ctl status`. The output should appear as such:
```
# gitlab-ctl status
run: logrotate: (pid 4856) 1859s; run: log: (pid 31262) 77460s
run: postgresql: (pid 30562) 77637s; run: log: (pid 30561) 77637s
run: redis: (pid 31898) 76464s; run: log: (pid 30520) 77643s
```

## Configure the Chart

### Create Secrets

We'll need to create as secret for the Redis password. The password value should be a securely generated string, which you set in the `gitlab.rb` above. Create it using `kubectl create secret generic external-redis --from-literal=redis-password=<value>`.

### Provide values

To connect the charts' services to the external databases, we'll need to set a few items. Below is a subset of items that show minimal configuration changes as opposed to using the `omnibus` chart, or other in-chart services. You can use these values via `--set` or in a yaml file provided to the helm command. It is suggested to use a file outside of CI to avoid errors in extremely long commands.

```YAML
gitlab:
  unicorn:
    redis:
      host: omnibus-vm.fqdn
      password:
        secret: external-redis
        key: redis-password
    psql:
      host: omnibus-vm.fqdn
      password: non-encoded-password
  sidekiq:
    redis:
      host: omnibus-vm.fqdn
      password:
        secret: external-redis
        key: redis-password
    psql:
      host: omnibus-vm.fqdn
      password: non-encoded-password
  omnibus:
    redis:
      enabled: false
      host: omnibus-vm.fqdn
      password:
        secret: external-redis
        key: redis-password
    psql:
      enabled: false
      host: gl-db.home
      password: supercalifragic
```

These values were combined with [`example-config.yaml`]() to create `external.yaml` used below. Remove any other configuration for Redis & PostgreSQL that may be present.

## Deploy!

Once you have a complete configuration in YAML, provide that to the Helm command.

`helm install -f external.yaml .`

[Omnibus GitLab]: https://about.gitlab.com/installation/#ubuntu

# External PostgreSQL database

This document assumes that you have an external PostgreSQL that is up and running.

If you need to spawn a postgresql instance for non-production purposes follow setting up [external omnibus postgresql instance](./external-omnibus-psql.md)

## Configure the Chart

The `migrations`, `unicorn`, and `sidekiq` charts require a PostgreSQL database to function. When not using the GitLab chart's provided service, we'll need to provide the configuration information to all three. Each chart can be configured individually on a per-chart basis, or you can make use of global values to configure all charts from a single point.

The PostgreSQL password must be provided to the deployment via a `Secret`. The [Secrets documentation][secrets] shows how to create a secret with random value. You can either use the random value, or enter your own. If you use your own when configuring the PostgreSQL database, ensure that this secret is created with that value. If you chose to use the random value, be sure to provided the decoded value to your PostgreSQL database.

You need to set `postgresql.install=false`, `global.psql.host`, `global.psql.password.secret` and `global.psql.password.key`values via helm's `--set` flag while deploying

```
helm install
  --set postgresql.install=false
  --set global.psql.host=omnibus-vm
  --set global.psql.password.secret=psql-secret
  --set global.psql.password.key=<key>
```

You can also set the port number useing `global.psql.port` setting. Default is assumed to be `5432`


> For a description for these configurations [lookup](../installation/command-line-options.md)

[secrets]: ../../installation/secrets.md#postgres-password
[deployment]: ../../installation/deployment.md

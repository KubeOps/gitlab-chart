# Secrets

For a functional deployment, different types of secrets are needed:

* TLS certificates for GitLab
* TLS certificates for Registry
* Passwords for individual components

## Certificates

We advise that wildcard certificates are obtained to prevent the need to
generate and maintain multiple sets of TLS certificates.

For this guide, we will be describing the use of wildcard
certificates. Ensure that the `.crt` file used is a properly structured full-chain
certificate.


> Note: GitLab Inc. employees have access to certificates generated specifically for
development in this project. They are located in the `Cloud Native`
vault in `1Password`.

### GitLab certificates

#### Lets Encrypt

If you are going to make use of Let's Encrypt certificates via [kube-lego](../kube-lego/README.md), then you can skip over [Wildcard certificates](#wildcard-certificates) and move to [Registry certificates](#registry-certificates)

#### Wildcard certificates
Add the TLS wildcard certificate to cluster secrets with:

```
$ kubectl create secret tls <name> --cert=<path/to.crt> --key=<path/to.key>

secret "<name>" created
```

For example, if we assume that our key-certificate pair is located in `certs` directory,
and that we are creating a secret named `helm-charts-win-tls`, command will look
something like:

```
$ kubectl create secret tls helm-charts-win-tls --cert=certs/-.helm-charts.win.chained.crt --key=certs/-.helm-charts.win.key
```

### Registry certificates

Communication between GitLab and Registry is happening behind an Ingress or a
Load Balancer so it is sufficient in most cases to use self-signed certificates
for this communication. If this traffic is exposed over a network, you
should generate valid certificates.

In the example below, we assume that we require self-signed certificates.

Generate a certificate-key pair:

```
$ openssl req -new -newkey rsa:4096 -subj="/CN=gitlab-issuer" -nodes -x509 -keyout certs/helm-charts-win-registry.key -out certs/helm-charts-win-registry.crt
```

Create a secret containing these certificates.
 We will create `registry-auth.key` and `registry-auth.crt` keys inside the
`gitlab-registry` secret.

```
$ kubectl create secret generic gitlab-registry --from-file=registry-auth.key=certs/helm-charts-win-registry.key --from-file=registry-auth.crt=certs/helm-charts-win-registry.crt
```

In more isolated clusters, these certificates can be in separate secrets, as long
as the configuration information as to which secret to use is passed to the appropriate
chart.

## Passwords

### Redis password

We'll generate a random 64 character alpha-numeric password for Redis.

```
$ kubectl create secret generic gitlab-redis --from-literal=redis-password=<password>
```
> Note: GitLab Inc. employees have this password generated and stored in `1Password Cloud Native` vault for development in this project.


### Secret tokens for services

Generate secret tokens for authenticating communication with GitLab Shell and Gitaly. Run the following command from
the root of this repo:

```
$ ./scripts/create-secret-tokens
```

Once all secrets have been generated and stored, you can proceed to generating
a [Configuration file](README.md#configuration-file).

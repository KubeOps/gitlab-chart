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
certificate. Not using the full-chain certificate will result in a broken chain causing
the certificate to not be trusted by many clients.

> Note: GitLab Inc. employees have access to certificates generated specifically for
development in this project. They are located in the `Cloud Native`
vault in `1Password`. Only the `*chained.crt` certificate should be used.

### GitLab certificates

#### Lets Encrypt

If you are going to make use of Let's Encrypt certificates via [kube-lego](../kube-lego/README.md), then you can skip over [Wildcard certificates](#wildcard-certificates) and move to [Registry certificates](#registry-certificates)

#### Wildcard certificates
Add the TLS wildcard certificate to cluster secrets with:

```
kubectl create secret tls <name> --cert=<path/to.crt> --key=<path/to.key>

secret "<name>" created
```

For example, if we assume that our key-certificate pair is located in `certs` directory,
and that we are creating a secret named `example-local-tls`, command will look
something like:

```
kubectl create secret tls example-local-tls --cert=certs/-.example.local.chained.crt --key=certs/-.example.local.key
```

### Registry certificates

Communication between GitLab and Registry is happening behind an Ingress or a
Load Balancer so it is sufficient in most cases to use self-signed certificates
for this communication. If this traffic is exposed over a network, you
should generate valid certificates.

In the example below, we assume that we require self-signed certificates.

Generate a certificate-key pair:

```
mkdir -p certs
openssl req -new -newkey rsa:4096 -subj "/CN=gitlab-issuer" -nodes -x509 -keyout certs/registry-example-local.key -out certs/registry-example-local.crt
```

Create a secret containing these certificates.
 We will create `registry-auth.key` and `registry-auth.crt` keys inside the
`gitlab-registry` secret.

```
kubectl create secret generic gitlab-registry --from-file=registry-auth.key=certs/registry-example-local.key --from-file=registry-auth.crt=certs/registry-example-local.crt
```

In more isolated clusters, these certificates can be in separate secrets, as long
as the configuration information as to which secret to use is passed to the appropriate
chart.

## Passwords

### Redis password

We'll generate a random 64 character alpha-numeric password for Redis.

```
kubectl create secret generic gitlab-redis --from-literal=redis-password=<password>
```
> Note: GitLab Inc. employees have this password generated and stored in `1Password Cloud Native` vault for development in this project.

### GitLab Shell

Generate a random secret for GitLab Shell.

```
kubectl create secret generic gitlab-shell-secret --from-literal=secret=$(head -c 512 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c 64)
```

### Gitaly Secret

```
kubectl create secret generic gitaly-secret --from-literal=token=$(head -c 512 /dev/urandom | tr -cd 'a-zA-Z0-9' | head -c 64)
```

### Minio Secret

```
$ ruby -e "require 'securerandom'; print SecureRandom.hex(20)" > ./minio_accesskey
$ ruby -e "require 'securerandom'; print SecureRandom.hex(64)" > ./minio_secretkey
$ kubectl create secret generic gitlab-minio --from-file=accesskey=minio_accesskey --from-file=secretkey=minio_secretkey
```

Once all secrets have been generated and stored, you can proceed to generating
a [Configuration file](README.md#configuration-file).

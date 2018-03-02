namespace={{ .Release.Namespace }}
release={{ .Release.Name }}
env={{ .Values.env }}

exit 1;

# Args pattern, length
function gen_random(){
  head -c 4096 /dev/urandom | LC_CTYPE=C tr -cd $1 | head -c $2
}

# Args: secretname, args
function generate_secret_if_needed(){
  secret_args=( "${@:2}")
  secret_name=$1
  if ! $(kubectl --namespace=$namespace get secret $secret_name > /dev/null 2>&1); then
    kubectl --namespace=$namespace create secret generic $secret_name ${secret_args[@]}
  else
    echo "secret \"$secret_name\" already exists"
  fi;
}

# Redis password
generate_secret_if_needed gitlab-redis --from-literal=redis-password=$(gen_random 'a-zA-Z0-9' 64)

# Postgres password

generate_secret_if_needed gitlab-postgres --from-literal=psql-password=$(gen_random 'a-zA-Z0-9' 64)

# Gitlab shell
generate_secret_if_needed gitlab-shell-secret --from-literal=secret=$(gen_random 'a-zA-Z0-9' 64)

# Gitaly secret
generate_secret_if_needed gitaly-secret --from-literal=token=$(gen_random 'a-zA-Z0-9' 64)

# Minio secret
generate_secret_if_needed gitlab-minio --from-literal=accesskey=$(gen_random 'a-zA-Z0-9' 64) --from-literal=secretkey=$(gen_random 'a-zA-Z0-9' 64)

# Registry certificates
mkdir -p certs
openssl req -new -newkey rsa:4096 -subj "/CN=gitlab-issuer" -nodes -x509 -keyout certs/registry-example-local.key -out certs/registry-example-local.crt
generate_secret_if_needed gitlab-registry --from-file=registry-auth.key=certs/registry-example-local.key --from-file=registry-auth.crt=certs/registry-example-local.crt

# config/secrets.yaml
if [ -n "$env" ]; then
  secret_key_base=$(gen_random 'a-f0-9' 128) # equavilent to secureRandom.hex(64)
  otp_key_base=$(gen_random 'a-f0-9' 128) # equavilent to secureRandom.hex(64)
  db_key_base=$(gen_random 'a-f0-9' 128) # equavilent to secureRandom.hex(64)
  openid_connect_signing_key=$(openssl genrsa 2048);

  cat << EOF > secrets.yml
  $env:
  secret_key_base: $secret_key_base
  otp_key_base: $otp_key_base
  db_key_base: $db_key_base
  openid_connect_signing_key: |
  $(openssl genrsa 2048 | awk '{print "    " $0}')
EOF
  generate_secret_if_needed rails-secrets --from-file secrets.yml
fi

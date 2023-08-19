#!/bin/bash

ENVIRONMENT='dev'
PROJECT_NAME='basic_infrastructure'
ANSIBLE_VAULT_TOKEN="$(vault token create -policy="$PROJECT_NAME"_"$ENVIRONMENT" | grep 'token ' | awk '{print $NF}')"

export ANSIBLE_VAULT_HOST='https://localhost'
export ANSIBLE_VAULT_PORT=45951
export ANSIBLE_VAULT_MOUNT_POINT='project'
export ANSIBLE_VAULT_CACERT='/opt/vault/tls/server/ca.pem'
export ANSIBLE_VAULT_CLIENT_CERT='/opt/vault/tls/client/cert.pem'
export ANSIBLE_VAULT_CLIENT_KEY='/opt/vault/tls/client/cert.key'
export ANSIBLE_VAULT_SECRET_PATH='infrastructure/basic'
export ANSIBLE_VAULT_TOKEN

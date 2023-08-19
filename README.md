# Basic configuration of Linux servers

## Description

A `ansible` playbook for the basic configuration of `debian` servers, but it was tested only on `debian 12`. By default,
the playbook is configured to receive secrets from the [hashicorp vault](https://developer.hashicorp.com/vault/docs), 
but you can set environment variables with the same name in uppercase with a prefix at the beginning or enter values in 
stdin. The prefix defined in `env_node_prefix` variable for each node and a common prefix stored in `env_common_prefix` 
variable. For example, if `env_node_prefix` equal `INFRA_NODE0_` and required variable is `ansible_port`, then the 
environment variable must be defined as `INFRA_NODE0_ANSIBLE_PORT`. First, the definition of variables in the playbook 
is checked, then the environment variables are searched, in case of their absence, a request appears to enter values in 
stdin. The list of secret variables is stored in the `secret` variable as a string list.

## Tasks

* Updating and upgrading system packages
* Changing `root` password
* Creating `ansible` user
* Configuring `SSH` server
* Configuring `iptables`
* Configuring timezone
* Configuring hostname

## Variables

### Hosts

Variables for each node defined in `hosts.yml`. Thanks to the dynamic path to the secret defined in the `vault_secret` 
variable, in order to avoid code duplication, it turned out to put the following variables in the `vars` common block:

* `vault_secret` - path to vault secret with environment and node name
* `ansible_port` - new ansible/ssh port
* `ansible_user` - new ansible/ssh user
* `ansible_password` - new ansible user password
* `root_password` - new root password
* `init_root_password` - initial root password
* `init_ansible_port` - initial ansible/ssh port
* `init_ansible_user` - initial ansible/ssh user
* `init_ansible_password` - initial ansible user password

Remaining variables for each node

* `ansible_host` - ip of host
* `env_node_prefix` - environment node prefix

### Group vars

* `env` - environment (dev or prod)
* `timezone` - timezone
* `ssh_key_type` - type of ssh key (rsa, ecdsa, ed25519, etc)
* `domain` - domain name
* `env_common_prefix` - environment common prefix
* `vault_secret_path` - path to vault secret without environment and node name
* `vault_token` - vault token
* `vault_host` - vault host with a protocol
* `vault_port` - vault port
* `vault_mount_point` - vault secret mount point
* `vault_cacert` - vault ca cert path
* `vault_module` - ansible module name for connection to the vault server
* `vault_data` - data for connection to the vault server
* `vault_data.url` - vault host with port
* `vault_data.auth_method` - vault auth method
* `vault_data.engine_mount_point` - vault secret mount point
* `vault_data.validate_certs` - is validate ca of the vault server
* `vault_data.ca_cert` - vault ca cert path
* `secrets` - list of secret variables to checking and definition

## Preparing a `bastion` station

```shell
python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install ansible passlib hvac
ansible-galaxy collection install community.hashi_vault
. bin/setenv.sh
```

In the case of using [hashicorp vault](https://developer.hashicorp.com/vault/docs), you need to set the following
environment variables, because for unknown reason, the `cert_auth_private_key` and `cert_auth_public_key` named 
arguments of the `community.hashi_vault.vault_kv2_get` lookup doesn't work. 

```shell
export VAULT_CLIENT_CERT="<VAULT_CLIENT_CERT_PATH>"
export VAULT_CLIENT_KEY="<VAULT_CLIENT_KEY_PATH>"
```

## Run tasks

```shell
ansible-playbook -i inventory/<ENVIRONMENT> -t base provision.yml
```

## Author

Internet & Energy labs

[admin@ie.icu](mailto:admin@ie.icu)

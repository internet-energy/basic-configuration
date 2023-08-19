Port {{ backup_ansible_port }}
ListenAddress {{ ansible_host }}
Protocol 2
PermitRootLogin no
AllowUsers {{ backup_ansible_user }}
PasswordAuthentication no
ChallengeResponseAuthentication no
AuthorizedKeysFile	.ssh/authorized_keys
KbdInteractiveAuthentication no
UsePAM yes
Subsystem       sftp    /usr/lib/openssh/sftp-server

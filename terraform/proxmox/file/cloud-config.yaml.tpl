#cloud-config
users:
  - default
  - name: ${username}
    groups:
      - sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    %{ if length(ssh_public_key) > 0 }
    ssh_authorized_keys:
      %{ for key in ssh_public_key }
      - ${key}
      %{ endfor }
    %{ endif }
write_files:
  - path: /tmp/cloud-config.done
    content: |
      Cloud configuration is done.
    permissions: '0644'
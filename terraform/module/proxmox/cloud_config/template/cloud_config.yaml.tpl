#cloud-config
bootcmd:
  - netplan apply
hostname: ${hostname}
groups:
  - docker: ["${username}"]
users:
  - default
  - name: ${username}
    groups: sudo
    ssh_import_id:
      - gh:${github.username}
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    %{ if password != null }
    passwd: ${password}
    lock_passwd: false
    %{ endif }

  
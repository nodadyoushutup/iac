#cloud-config
hostname: ${hostname}
groups:
  - docker: ["${username}"]
users:
  - default
  - name: ${username}
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    %{ if password != null }
    passwd: ${password}
    lock_passwd: false
    %{ endif }
write_files:
  - encoding: b64
    content: ${base64.netplan}
    owner: root:root
    path: /tmp/netplan.sh
  - encoding: b64
    content: ${base64.ssh_import}
    owner: root:root
    path: /tmp/ssh_import.sh
    permissions: '0777'
  - encoding: b64
    content: ${base64.apt}
    owner: root:root
    path: /tmp/apt.sh
    permissions: '0777'
  - encoding: b64
    content: ${base64.docker}
    owner: root:root
    path: /tmp/docker.sh
    permissions: '0777'
runcmd:
  - /tmp/netplan.sh
  - /tmp/apt.sh
  - /tmp/docker.sh ${username}
  %{ if github != null }
  - /tmp/ssh_import.sh ${username} {github}'
  %{ else }
  - echo 'No SSH import'
  %{ endif }
  
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
runcmd:
  %{ if github != null }
  - su - ${username} -c 'ssh-import-id gh:${github}'
  %{ else }
  - echo 'No SSH import'
  %{ endif }
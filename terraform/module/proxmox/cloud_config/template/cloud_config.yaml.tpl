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
  - groupadd -f docker
  %{ if github != null }
  - echo 'No SSH import'
  %{ else }
  - echo 'No SSH import'
  %{ endif }
  
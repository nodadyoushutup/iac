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
    passwd: $6$rounds=4096$.CJERIoepNubjNIf$FYJTjkrDMM1dcCrcDRgAv22xVTkRPx3L8x8rlPG8Hitwy1s0ZZpaasjdSiUCOx4dcM61xNpl.X1pSO0fU1Aoo/
    lock_passwd: false
runcmd:
  %{ if github != null }
  - su - ${username} -c 'ssh-import-id gh:${github}'
  %{ else }
  - echo 'No SSH import'
  %{ endif }
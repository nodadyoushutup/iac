#cloud-config
hostname: ${hostname}
groups:
  - docker: ["${auth.username}"]
users:
  - default
  - name: "${auth.username}"
    groups: sudo
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    passwd: $6$rounds=4096$.CJERIoepNubjNIf$FYJTjkrDMM1dcCrcDRgAv22xVTkRPx3L8x8rlPG8Hitwy1s0ZZpaasjdSiUCOx4dcM61xNpl.X1pSO0fU1Aoo/
    lock_passwd: false
    %{ if length(auth.ssh_public_key) > 0 }
    ssh-authorized-keys:
      %{ for key in auth.ssh_public_key }
      - ${key}
      %{ endfor }
    %{ endif }
bootcmd: 
  - echo 'testing1234' > /tmp/testing1234.txt
  - dhclient -v eth0
runcmd:
  - ${ssh_import}
  %{ for cmd in runcmd }
  - ${cmd}
  %{ endfor }
  - echo "done" > /tmp/cloud-config.done
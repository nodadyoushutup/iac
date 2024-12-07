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
  - path: /etc/fstab
    content: |
      LABEL=cloudimg-rootfs   /        ext4   discard,errors=remount-ro       0 1  
      LABEL=UEFI      /boot/efi       vfat    umask=0077      0 1
      %{ if length(truenas.nfs) > 0 }
      %{ for share in truenas.nfs }
      ${truenas.ip_address.internal}:${share.src} ${share.dest} nfs defaults 0 0
      %{ endfor }
      %{ endif }
    permissions: '0644'
runcmd:
  - echo 'cloud-config runcmd'
  %{ if length(truenas.nfs) > 0 }
  %{ for share in truenas.nfs }
  - mkdir -p ${share.dest}
  %{ endfor }
  %{ endif }
  - mount -a
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
  - path: /tmp/fstab
    content: |
      LABEL=cloudimg-rootfs   /        ext4   discard,errors=remount-ro       0 1  
      LABEL=UEFI      /boot/efi       vfat    umask=0077      0 1
      %{ for share in truenas.nfs }
      ${truenas.ip_address.internal}:${share.src} ${share.dest} nfs defaults 0 0
      %{ endfor }
      192.168.1.100:/mnt/epool/media /mnt/epool/media nfs defaults 0 0
      192.168.1.100:/mnt/epool/config /mnt/epool/config nfs defaults 0 0
    permissions: '0644'
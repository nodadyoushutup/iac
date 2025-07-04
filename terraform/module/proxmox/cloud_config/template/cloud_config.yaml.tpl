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
    %{ if github != null && github.username != null }
    ssh_import_id:
      - gh:${github.username}
    %{ endif }
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    %{ if password != null }
    passwd: ${password}
    lock_passwd: false
    %{ endif }
%{ if mounts != null && length(mounts) > 0 }
mounts:
%{ for mnt in mounts ~}
- ${mnt}
%{ endfor }
mount_default_fields: [None, None, auto, "defaults,nofail", "0", "2"]
%{ endif }
write_files:
  - encoding: b64
    content: ${base64.gitconfig}
    owner: ${username}:${username}
    path: /tmp/.gitconfig
    permissions: "0644"
runcmd:
  - mv /tmp/.gitconfig /home/${username}/.gitconfig

  
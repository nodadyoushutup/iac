#cloud-config
bootcmd:
  - netplan apply
hostname: ${hostname}
groups:
  - docker: ["${username}"]
users:
  - default
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
- ${user}
%{ endfor }
%{ endif }
chpasswd:
  expire: false
  users:
  - {name: ${username}, password: password1, type: text}
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

  
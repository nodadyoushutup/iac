#cloud-config
bootcmd:
  - netplan apply

hostname: ${hostname}

groups:
  - docker: [
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
      "${jsondecode(user).name}",
%{ endfor }
    ]
%{ else }
  - docker: []
%{ endif }

users:
  - default
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
  - ${user}
%{ endfor }
%{ endif }

%{ if mounts != null && length(mounts) > 0 }
mounts:
%{ for mnt in mounts ~}
  - ${mnt}
%{ endfor }
mount_default_fields: [None, None, auto, "defaults,nofail", "0", "2"]
%{ endif }

write_files:
%{ if gitconfig != null }
  - path: /tmp/.gitconfig
    encoding: b64
    content: ${base64.gitconfig}
%{ endif }


runcmd:
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
  - cp /tmp/.gitconfig /home/${jsondecode(user).name}/.gitconfig
  - chown ${jsondecode(user).name}:${jsondecode(user).name} /home/${jsondecode(user).name}/.gitconfig
%{ endfor }
%{ endif }
  - rm -rf /tmp/.gitconfig

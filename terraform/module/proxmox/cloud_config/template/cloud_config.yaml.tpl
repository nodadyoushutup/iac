#cloud-config
bootcmd:
  - netplan apply

hostname: ${hostname}

groups:
  - docker: [
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
      "${user.name}",
%{ endfor }
    ]
%{ else }
  - docker: []
%{ endif }

users:
  - default
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
  - ${jsonencode({
        for k, v in user : k => v if v != null
      })}
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
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
  - encoding: b64
    content: ${base64_gitconfig_content}
    owner: ${user.name}:${user.name}
    path: /tmp/.gitconfig-${user.name}
    permissions: "0644"
%{ endfor }
%{ endif }

runcmd:
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
  - mv /tmp/.gitconfig-${user.name} /home/${user.name}/.gitconfig
  - chown ${user.name}:${user.name} /home/${user.name}/.gitconfig
%{ endfor }
%{ endif }

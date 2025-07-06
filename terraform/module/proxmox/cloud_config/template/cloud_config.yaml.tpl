#cloud-config
bootcmd:
  - netplan apply

hostname: ${hostname}

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

%{ if groups != null && length(groups) > 0 }
groups:
%{ if can(groups[0]) }
%{ for group in groups ~}
  - "${group}"
%{ endfor }
%{ else }
%{ for group, members in groups ~}
  - ${group}: [%{ for member in members ~}"${member}",%{ endfor }]
%{ endfor }
%{ endif }
%{ endif }

write_files:
%{ if write_files != null && length(write_files) > 0 }
%{ for write_file in write_files_gitconfig ~}
  - ${write_file}
%{ endfor }
%{ for write_file in write_files ~}
  - ${write_file}
%{ endfor }
%{ endif }


runcmd:
%{ if users != null && length(users) > 0 }
%{ for user in users ~}
%{ if gitconfig != null && gitconfig.github_pat != null }
  - su - ${jsondecode(user).name} -c "/script/register_github_public_key.sh ${gitconfig.github_pat}"
%{ endif }
%{ endfor }
%{ endif }

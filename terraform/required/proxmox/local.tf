# locals {
#     template = {
#         gitconfig = templatefile(
#             "${path.module}/../proxmox/template/.gitconfig.tpl", 
#             {
#                 git_gitconfig_name = var.git.gitconfig.name,
#                 git_gitconfig_email = var.git.gitconfig.email
#             }
#         )
#         private_key = templatefile(
#             "${path.module}/../proxmox/template/id_rsa.tpl", 
#             {
#                 id_rsa = file(var.SSH_PRIVATE_KEY)
#             }
#         )
#     }

#     exec = {
#         inline = {
#             gitconfig = [
#                 "cat <<EOF > /tmp/.gitconfig",
#                 "${local.template.gitconfig}",
#                 "EOF",
#                 "cp -p /tmp/.gitconfig /home/${local.machine.global.username}/.gitconfig",
#                 "chown ${local.machine.global.username}:${local.machine.global.username} /home/${local.machine.global.username}/.gitconfig",
#                 "rm -rf /tmp/.gitconfig",
#             ]
#             private_key = [
#                 "cat <<EOF > /tmp/id_rsa",
#                 "${local.template.private_key}",
#                 "EOF",
#                 "cp -p /tmp/id_rsa /home/${local.machine.global.username}/.ssh/id_rsa",
#                 "chown ${local.machine.global.username}:${local.machine.global.username} /home/${local.machine.global.username}/.ssh/id_rsa",
#                 "chmod 600 /home/${local.machine.global.username}/.ssh/id_rsa",
#                 "rm -rf /tmp/id_rsa",
#             ]
#         }   
#     }
# }
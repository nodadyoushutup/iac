locals {
    template = {
        gitconfig = templatefile(
            "${path.module}/../proxmox/template/.gitconfig.tpl", 
            {
                GITCONFIG_NAME = var.GITCONFIG_NAME,
                GITCONFIG_EMAIL = var.GITCONFIG_EMAIL
            }
        )
        private_key = templatefile(
            "${path.module}/../proxmox/template/id_rsa.tpl", 
            {
                ID_RSA = file(var.SSH_PRIVATE_KEY)
            }
        )
    }

    exec = {
        inline = {
            gitconfig = [
                "cat <<EOF > /tmp/.gitconfig",
                "${local.template.gitconfig}",
                "EOF",
                "cp -p /tmp/.gitconfig /home/${var.machine.global.user}/.gitconfig",
                "chown ${var.machine.global.user}:${var.machine.global.user} /home/${var.machine.global.user}/.gitconfig",
                "rm -rf /tmp/.gitconfig",
            ]
            private_key = [
                "cat <<EOF > /tmp/id_rsa",
                "${local.template.private_key}",
                "EOF",
                "chmod 600 /tmp/id_rsa",
                "cp -p /tmp/id_rsa /home/${var.machine.global.user}/.ssh/id_rsa",
                "chown ${var.machine.global.user}:${var.machine.global.user} /home/${var.machine.global.user}/.ssh/id_rsa",
                "chmod 600 /home/${var.machine.global.user}/.ssh/id_rsa",
                "rm -rf /tmp/id_rsa",
            ]
        }   
    }
}
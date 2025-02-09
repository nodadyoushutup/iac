locals {
    template = {
        gitconfig = templatefile(
            "${path.module}/template/.gitconfig.tpl", 
            {
                GITCONFIG_NAME=var.GITCONFIG_NAME,
                GITCONFIG_EMAIL=var.GITCONFIG_EMAIL
            }
        )
        private_key = templatefile(
            "${path.module}/template/id_rsa.tpl", 
            {
                ID_RSA=file(var.SSH_PRIVATE_KEY)
            }
        )
    }
    
    hostname = {
        docker = "docker"
        development = "development"
    }

    exec = {
        connection = {
            docker = {
                type = "ssh"
                user = var.VIRTUAL_MACHINE_USERNAME_GLOBAL
                private_key = file(var.SSH_PRIVATE_KEY)
                host = VIRTUAL_MACHINE_IP_ADDRESS_DOCKER
                port = 22
            }
            development = {
                type = "ssh"
                user = var.VIRTUAL_MACHINE_USERNAME_GLOBAL
                private_key = file(var.SSH_PRIVATE_KEY)
                host = var.VIRTUAL_MACHINE_IP_ADDRESS_DEVELOPMENT
                port = 22
            }
        }
        inline = {
            hostname = {
                docker = ["sudo hostnamectl set-hostname docker"]
                development = ["sudo hostnamectl set-hostname development"]
                restart = ["sudo systemctl restart systemd-hostnamed"]
            }
            gitconfig = [
                "cat <<EOF > /tmp/.gitconfig",
                "${local.template.gitconfig}",
                "EOF",
                "cp -p /tmp/.gitconfig /home/${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}/.gitconfig",
                "chown ${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}:${var.VIRTUAL_MACHINE_USERNAME_GLOBAL} /home/${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}/.gitconfig",
                "rm -rf /tmp/.gitconfig",
            ]
            private_key = [
                "cat <<EOF > /tmp/id_rsa",
                "${local.template.private_key}",
                "EOF",
                "chmod 600 /tmp/id_rsa",
                "cp -p /tmp/id_rsa /home/${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}/.ssh/id_rsa",
                "chown ${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}:${var.VIRTUAL_MACHINE_USERNAME_GLOBAL} /home/${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}/.ssh/id_rsa",
                "chmod 600 /home/${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}/.ssh/id_rsa",
                "rm -rf /tmp/id_rsa",
            ]
        }   
    }
}
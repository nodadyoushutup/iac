locals {
    template = {
        prometheus = templatefile(
            "${path.module}/../prometheus/template/prometheus.yml.tpl", 
            {
                VIRTUAL_MACHINE_DOCKER_IP_ADDRESS = var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS,
                VIRTUAL_MACHINE_DEVELOPMENT_IP_ADDRESS = var.VIRTUAL_MACHINE_DEVELOPMENT_IP_ADDRESS
            }
        )
    }
    
    exec = {
        connection = {
            docker = {
                type = "ssh"
                user = var.machine.global.user
                private_key = file(var.SSH_PRIVATE_KEY)
                host = var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS
                port = 22
            }
        }
        inline = {
            prometheus = [
                "cat <<EOF > /tmp/prometheus.yml",
                "${local.template.prometheus}",
                "EOF",
                "cp -p /tmp/prometheus.yml /home/${var.machine.global.username}/prometheus.yml",
                "chown ${var.machine.global.username}:${var.machine.global.username} /home/${var.machine.global.username}/prometheus.yml",
                "rm -rf /tmp/prometheus.yml",
            ]
        }   
    }
}
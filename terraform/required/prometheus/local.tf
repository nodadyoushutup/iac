locals {
    template = {
        prometheus = templatefile(
            "${path.module}/../prometheus/template/prometheus.yml.tpl", 
            {
                machine_required_docker_ipv4_address = var.machine.required.docker.ipv4.address,
                machine_required_development_ipv4_address = var.machine.required.development.ipv4.address
            }
        )
    }
    
    exec = {
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
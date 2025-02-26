locals {
    template = {
        prometheus = templatefile(
            "${path.module}/../prometheus/template/prometheus.yml.tpl", 
            {
                machine_required_docker_ipv4_address = local.config.machine.required.docker.ipv4.address,
                machine_required_development_ipv4_address = local.config.machine.required.development.ipv4.address
            }
        )
    }
    
    exec = {
        inline = {
            prometheus = [
                "cat <<EOF > /tmp/prometheus.yml",
                "${local.template.prometheus}",
                "EOF",
                "cp -p /tmp/prometheus.yml /home/${local.config.machine.global.username}/prometheus.yml",
                "chown ${local.config.machine.global.username}:${local.config.machine.global.username} /home/${local.config.machine.global.username}/prometheus.yml",
                "rm -rf /tmp/prometheus.yml",
            ]
        }   
    }
}
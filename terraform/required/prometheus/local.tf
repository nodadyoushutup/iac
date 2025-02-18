locals {
    template = {
        prometheus = templatefile(
            "${path.module}/../prometheus/template/prometheus.yml.tpl", 
            {
                machine_required_docker_ipv4_address = local.machine.required.docker.ipv4.address,
                machine_required_development_ipv4_address = local.machine.required.development.ipv4.address
            }
        )
    }
    
    exec = {
        inline = {
            prometheus = [
                "cat <<EOF > /tmp/prometheus.yml",
                "${local.template.prometheus}",
                "EOF",
                "cp -p /tmp/prometheus.yml /home/${local.machine.global.username}/prometheus.yml",
                "chown ${local.machine.global.username}:${local.machine.global.username} /home/${local.machine.global.username}/prometheus.yml",
                "rm -rf /tmp/prometheus.yml",
            ]
        }   
    }
}
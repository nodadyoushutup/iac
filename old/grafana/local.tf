locals {
    template = {
        grafana = {
            cadvisor = templatefile(
                "${path.module}/../grafana/template/cadvisor.json.tpl", 
                {
                    datasource = "prometheus"
                }
            )
            node_exporter = templatefile(
                "${path.module}/../grafana/template/node_exporter.json.tpl", 
                {
                    datasource = "prometheus",
                    machine_required_docker_ipv4_address = local.config.machine.required.docker.ipv4.address
                    machine_required_docker_ipv4_address = local.config.machine.required.docker.ipv4.address
                }
            )
        }
    }
}
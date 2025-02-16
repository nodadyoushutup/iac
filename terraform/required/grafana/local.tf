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
                    VIRTUAL_MACHINE_DOCKER_IP_ADDRESS = var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS
                }
            )
        }
    }
}
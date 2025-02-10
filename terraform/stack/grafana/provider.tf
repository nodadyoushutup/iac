terraform {
    required_providers {
        grafana = {
            source  = "grafana/grafana"
            version = "3.18.3"
        }
    }
}

provider "grafana" {
  url  = "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:3000"
  auth = "grafana:grafana"
}
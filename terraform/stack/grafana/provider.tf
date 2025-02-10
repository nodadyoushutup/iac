provider "grafana" {
  url  = "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:3000"
  auth = "grafana:grafana"
}
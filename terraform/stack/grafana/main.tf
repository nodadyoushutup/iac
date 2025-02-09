resource "docker_image" "grafana" {
    name = "grafana/grafana:11.5.1"
}

resource "docker_volume" "grafana" {
    name = "grafana"
}

# resource "docker_container" "grafana" {
#     depends_on = [
#         docker_image.grafana
#     ]
#     name  = "grafana"
#     image = docker_image.grafana.image_id
#     restart = "unless-stopped"
#     privileged = true
    
#     ports {
#         internal = "3000"
#         external = "3000"
#     }

#     volumes {
#         host_path = "/home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/prometheus.yml"
#         container_path = "/etc/prometheus/prometheus.yml"
#     }
# }
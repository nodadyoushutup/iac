resource "docker_image" "prometheus" {
    name = "prom/prometheus:v3.1.0"
}

resource "docker_container" "prometheus" {
  depends_on = [docker_image.prometheus]
  name  = "prometheus"
  image = docker_image.prometheus.image_id
  restart = "unless-stopped"
  privileged = true
#   wait = true
  
  ports {
    internal = "9090"
    external = "9090"
  }

  volumes {
    host_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

#   healthcheck {
#     test = ["CMD", "/dozzle", "healthcheck"]
#     interval = "5s"
#     retries = 12
#   }
}
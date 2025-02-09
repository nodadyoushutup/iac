resource "null_resource" "exec_prometheus" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type = local.exec.connection.docker.type
    user = local.exec.connection.docker.user
    private_key = local.exec.connection.docker.private_key
    host = local.exec.connection.docker.host
    port = local.exec.connection.docker.port
  }

  provisioner "remote-exec" {
    inline = concat(
      local.exec.inline.prometheus
    )
  }
}

resource "docker_image" "prometheus" {
  depends_on = [null_resource.exec_prometheus]
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
    host_path = "./prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

#   healthcheck {
#     test = ["CMD", "/dozzle", "healthcheck"]
#     interval = "5s"
#     retries = 12
#   }
}
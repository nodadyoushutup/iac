resource "null_resource" "exec_prometheus" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type = "ssh"
    user = local.config.machine.global.username
    private_key = file(var.SSH_PRIVATE_KEY)
    host = local.config.machine.required.docker.ipv4.address
    port = 22
  }

  provisioner "remote-exec" {
    inline = concat(
      local.exec.inline.prometheus
    )
  }
}

resource "docker_image" "prometheus" {
  depends_on = [null_resource.exec_prometheus]
  name = "prom/prometheus:v3.2.1"
}

resource "docker_container" "prometheus" {
  depends_on = [docker_image.prometheus]
  name  = "prometheus"
  image = docker_image.prometheus.image_id
  restart = "unless-stopped"
  privileged = true
  # wait = true
  network_mode = "bridge"
  
  ports {
    internal = "9090"
    external = "9090"
  }

  volumes {
    host_path = "/home/${local.config.machine.global.username}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  # healthcheck {
  #   test = ["CMD", "curl", "-f", "http://${local.config.machine_required_docker_ipv4_address}:9090"]
  #   interval = "5s"
  #   retries = 12
  # }
}
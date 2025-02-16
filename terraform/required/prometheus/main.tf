resource "null_resource" "exec_prometheus" {
  triggers = {
    always_run = timestamp()
  }

  connection {
    type = "ssh"
    user = var.machine.global.username
    private_key = file(var.SSH_PRIVATE_KEY)
    host = var.machine.required.docker.ipv4.address
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
  name = "prom/prometheus:v3.1.0"
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
    host_path = "/home/${var.machine.global.username}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  # healthcheck {
  #   test = ["CMD", "curl", "-f", "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:9090"]
  #   interval = "5s"
  #   retries = 12
  # }
}
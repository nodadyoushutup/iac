resource "docker_image" "dozzle" {
  name = "amir20/dozzle:v8.13.4"
}

resource "docker_container" "dozzle" {
  depends_on = [docker_image.dozzle]
  name  = "dozzle"
  image = docker_image.dozzle.image_id
  restart = "unless-stopped"
  wait = true
  network_mode = "bridge"
  
  ports {
    internal = "8080"
    external = "8081"
  }

  volumes {
    host_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  healthcheck {
    test = ["CMD", "/dozzle", "healthcheck"]
    interval = "5s"
    retries = 12
  }
}
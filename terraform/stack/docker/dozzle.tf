resource "docker_image" "dozzle" {
    name = "amir20/dozzle:v8.10.6"
}

resource "docker_container" "jenkins" {
  depends_on = [docker_image.dozzle]
  name  = "dozzle"
  image = docker_image.dozzle.image_id
  restart = "unless-stopped"
#   wait = true
  
  ports {
    internal = "8080"
    external = "8081"
  }

  volumes {
    host_path = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

#   healthcheck {
#     test = ["CMD", "curl", "-f", "http://192.168.1.101:8080/whoAmI/api/json?tree=authenticated"]
#     interval = "5s"
#     retries = 12
#   }
}
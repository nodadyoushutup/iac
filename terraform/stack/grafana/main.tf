resource "docker_image" "grafana" {
    name = "grafana/grafana:11.5.1"
}

resource "docker_volume" "grafana" {
    name = "grafana"
}

resource "docker_container" "grafana" {
    depends_on = [
        docker_image.grafana,
        docker_volume.grafana
    ]
    name  = "grafana"
    image = docker_image.grafana.image_id
    restart = "unless-stopped"
    privileged = true
    
    ports {
        internal = "3000"
        external = "3000"
    }

    volumes {
        volume_name = docker_volume.grafana.name
        container_path = "/var/lib/grafana"
    }
}
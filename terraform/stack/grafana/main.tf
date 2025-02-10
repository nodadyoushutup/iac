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
    wait = true

    env = [
        "GF_SECURITY_ADMIN_USER=grafana",
        "GF_SECURITY_ADMIN_PASSWORD=grafana"
    ]
    
    ports {
        internal = "3000"
        external = "3000"
    }

    volumes {
        volume_name = docker_volume.grafana.name
        container_path = "/var/lib/grafana"
    }

    healthcheck {
        test = ["CMD", "curl", "-f", "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:3000/healthz"]
        interval = "5s"
        retries = 12
    }
}

resource "grafana_data_source" "prometheus" {
    depends_on = [docker_container.grafana]
    type = "prometheus"
    name = "prometheus"
    url = "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:9090"
    uid = "prometheus"
    is_default = true
    json_data_encoded = jsonencode({
        httpMethod = "POST"
        prometheusType = "Mimir"
        prometheusVersion = "2.4.0"
    })
}

resource "grafana_dashboard" "test" {
    depends_on = [grafana_data_source.prometheus]
    config_json = jsonencode(file("${path.module}/template/cadvisor.json"))
}
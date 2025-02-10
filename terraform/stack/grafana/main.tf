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
        test = ["CMD", "curl", "-f", "http://192.168.1.102:3000/healthz"]
        interval = "5s"
        retries = 12
    }
}

resource "grafana_connections_metrics_endpoint_scrape_job" "prometheus" {
    depends_on = [docker_container.grafana]
    stack_id = "1"
    name = "prometheus"
    enabled = true
    authentication_method = "basic"
    url = "http://192.168.1.102:9090"
    scrape_interval_seconds = 15
}
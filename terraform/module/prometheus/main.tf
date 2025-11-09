locals {
  prometheus_config_yaml = yamlencode(var.prometheus_config)
  prometheus_config_sha  = sha256(local.prometheus_config_yaml)
}

resource "docker_network" "prometheus" {
  name   = "prometheus"
  driver = "overlay"
}

resource "docker_volume" "prometheus_data" {
  name = "prometheus-data"
}

resource "docker_config" "prometheus" {
  name = format("prometheus-%s.yml", substr(local.prometheus_config_sha, 0, 12))
  data = base64encode(local.prometheus_config_yaml)
}

resource "docker_service" "prometheus" {
  name = "prometheus"

  labels {
    label = "com.docker.stack.namespace"
    value = "prometheus"
  }

  labels {
    label = "com.docker.service"
    value = "prometheus"
  }

  task_spec {
    placement {
      platforms {
        os           = "linux"
        architecture = "arm64"
      }
      constraints = ["node.labels.role==monitoring"]
    }

    networks_advanced {
      name        = docker_network.prometheus.id
      aliases     = []
      driver_opts = []
    }

    container_spec {
      image = "prom/prometheus:v3.7.3@sha256:49214755b6153f90a597adcbff0252cc61069f8ab69ce8411285cd4a560e8038"

      args = [
        "--config.file=/etc/prometheus/prometheus.yml",
        "--storage.tsdb.path=/prometheus",
        "--storage.tsdb.retention.time=15d",
        "--web.enable-lifecycle",
      ]

      mounts {
        target = "/prometheus"
        source = docker_volume.prometheus_data.name
        type   = "volume"
      }

      configs {
        config_id   = docker_config.prometheus.id
        config_name = docker_config.prometheus.name
        file_name   = "/etc/prometheus/prometheus.yml"
      }

      healthcheck {
        test         = ["CMD", "wget", "--spider", "--quiet", "http://localhost:9090/-/healthy"]
        interval     = "10s"
        timeout      = "5s"
        retries      = 6
        start_period = "30s"
      }
    }
  }

  mode {
    replicated {
      replicas = 1
    }
  }

  endpoint_spec {
    ports {
      target_port    = 9090
      published_port = 9090
      publish_mode   = "ingress"
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
    replace_triggered_by = [
      docker_config.prometheus
    ]
  }
}

output "prometheus_config_sha" {
  description = "SHA256 of the rendered Prometheus configuration"
  value       = local.prometheus_config_sha
}

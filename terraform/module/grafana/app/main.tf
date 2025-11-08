locals {
  admin_password   = tostring(var.provider_config.grafana.password)
  grafana_ini_path = "${path.module}/grafana.ini"
}

data "docker_network" "external" {
  for_each = toset(["prometheus"])
  name     = each.value
}

resource "docker_network" "grafana" {
  name   = "grafana"
  driver = "overlay"
}

resource "docker_volume" "grafana_data" {
  name   = "grafana-data"
  driver = "local"
}

resource "docker_secret" "grafana_admin_password" {
  name = "grafana-admin-password"
  data = base64encode(local.admin_password)
}

resource "docker_config" "grafana_ini" {
  name = format("grafana-ini-%s", substr(sha256(file(local.grafana_ini_path)), 0, 12))
  data = filebase64(local.grafana_ini_path)
}

resource "docker_service" "grafana" {
  name = "grafana"

  labels {
    label = "com.docker.stack.namespace"
    value = "grafana"
  }

  labels {
    label = "com.docker.service"
    value = "grafana"
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
      name    = docker_network.grafana.id
      aliases = ["grafana"]
    }

    dynamic "networks_advanced" {
      for_each = data.docker_network.external

      content {
        name    = networks_advanced.value.id
        aliases = []
      }
    }

    container_spec {
      image = "grafana/grafana:11.1.0@sha256:bde5c7baab9cae482cf7ef7a4c4e6b52d035e4e7a4f9784fca3a875c8a459291"
      env = {
        GF_SECURITY_ADMIN_USER           = "admin"
        GF_SECURITY_ADMIN_PASSWORD__FILE = "/run/secrets/grafana-admin-password"
        GF_SERVER_HTTP_PORT              = "3000"
        GF_SERVER_ROOT_URL               = "https://grafana.nodadyoushutup.com"
        GF_USERS_ALLOW_SIGN_UP           = "false"
        GF_SERVER_DOMAIN                 = "grafana.nodadyoushutup.com"
        GF_INSTALL_PLUGINS               = "grafana-clock-panel,grafana-piechart-panel"
      }

      mounts {
        target = "/var/lib/grafana"
        source = docker_volume.grafana_data.name
        type   = "volume"
      }

      secrets {
        secret_id   = docker_secret.grafana_admin_password.id
        secret_name = docker_secret.grafana_admin_password.name
        file_name   = "/run/secrets/grafana-admin-password"
      }

      configs {
        config_id   = docker_config.grafana_ini.id
        config_name = docker_config.grafana_ini.name
        file_name   = "/etc/grafana/grafana.ini"
      }

      healthcheck {
        test         = ["CMD", "wget", "--spider", "--quiet", "http://localhost:3000/api/health"]
        interval     = "15s"
        timeout      = "5s"
        retries      = 5
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
      target_port    = 3000
      published_port = 3000
      protocol       = "tcp"
      publish_mode   = "ingress"
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
    replace_triggered_by = [
      docker_secret.grafana_admin_password,
      docker_config.grafana_ini,
    ]
  }
}

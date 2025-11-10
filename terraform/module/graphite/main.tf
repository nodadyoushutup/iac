locals {
  allowed_platforms = [
    {
      os           = "linux"
      architecture = "arm64"
    },
    {
      os           = "linux"
      architecture = "aarch64"
    }
  ]
}

resource "docker_network" "graphite" {
  name   = "graphite-net"
  driver = "overlay"
}

resource "docker_volume" "graphite_data" {
  name = "graphite-data"
}

resource "docker_service" "graphite" {
  name = "graphite"

  task_spec {
    placement {
      dynamic "platforms" {
        for_each = local.allowed_platforms

        content {
          os           = platforms.value.os
          architecture = platforms.value.architecture
        }
      }

      constraints = ["node.labels.role==monitoring"]
    }

    networks_advanced {
      name    = docker_network.graphite.id
      aliases = ["graphite"]
    }

    container_spec {
      image = "graphiteapp/graphite-statsd:1.1.10-5@sha256:ceb163a8f237ea1a5d2839589f6b5b7aef05153b12b05ed9fe3cec12fe10cf43"

      mounts {
        target = "/opt/graphite/storage"
        source = docker_volume.graphite_data.name
        type   = "volume"
      }
    }
  }

  endpoint_spec {
    ports {
      target_port    = 8080
      published_port = 8081
      protocol       = "tcp"
      publish_mode   = "ingress"
    }

    ports {
      target_port    = 2003
      published_port = 2003
      protocol       = "tcp"
      publish_mode   = "ingress"
    }

    ports {
      target_port    = 2003
      published_port = 2003
      protocol       = "udp"
      publish_mode   = "ingress"
    }

    ports {
      target_port    = 2004
      published_port = 2004
      protocol       = "tcp"
      publish_mode   = "ingress"
    }

    ports {
      target_port    = 8125
      published_port = 8125
      protocol       = "udp"
      publish_mode   = "ingress"
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
  }
}

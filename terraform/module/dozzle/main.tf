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

resource "docker_network" "dozzle" {
  name   = "dozzle"
  driver = "overlay"
}

resource "docker_service" "dozzle" {
  name = "dozzle"

  task_spec {
    placement {
      dynamic "platforms" {
        for_each = local.allowed_platforms

        content {
          os           = platforms.value.os
          architecture = platforms.value.architecture
        }
      }
    }

    networks_advanced {
      name        = docker_network.dozzle.id
      aliases     = []
      driver_opts = []
    }

    container_spec {
      image = "amir20/dozzle:v8.14.8@sha256:0f987e852dad0eea1c3465c85a4ff1eef5ce693bdee7d030950050f073ab7d4e"

      env = {
        DOZZLE_MODE = "swarm"
      }

      dns_config {
        nameservers = [
          "192.168.1.1",
          "1.1.1.1",
          "8.8.8.8",
        ]
      }

      mounts {
        target = "/var/run/docker.sock"
        source = "/var/run/docker.sock"
        type   = "bind"
      }

      healthcheck {
        test         = ["CMD", "/dozzle", "healthcheck"]
        interval     = "10s"
        timeout      = "5s"
        retries      = 30
        start_period = "1m"
      }
    }
  }

  mode {
    global = true
  }

  endpoint_spec {
    ports {
      target_port    = 8080
      published_port = 8888
      publish_mode   = "ingress"
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
  }
}

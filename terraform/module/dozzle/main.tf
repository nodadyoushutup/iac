resource "docker_network" "dozzle" {
  name   = "dozzle"
  driver = "overlay"
}

resource "docker_service" "dozzle" {
  name = "dozzle"

  task_spec {
    placement {
      platforms {
        os           = "linux"
        architecture = "arm64"
      }
    }

    networks_advanced {
      name        = docker_network.dozzle.id
      aliases     = []
      driver_opts = []
    }

    container_spec {
      image = "amir20/dozzle:v8.14.7@sha256:ca0e25216d1d934f7b16274b765c853565e7ce8bb7edff26e30177e57c9ba038"

      env = {
        DOZZLE_MODE = "swarm"
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

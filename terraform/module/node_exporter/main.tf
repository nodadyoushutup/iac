resource "docker_network" "node_exporter" {
  name   = "node-exporter"
  driver = "overlay"
}

resource "docker_service" "node_exporter" {
  name = "node-exporter"

  labels {
    label = "com.docker.stack.namespace"
    value = "node-exporter"
  }

  labels {
    label = "com.docker.service"
    value = "node-exporter"
  }

  task_spec {
    placement {
      platforms {
        os           = "linux"
        architecture = "arm64"
      }
    }

    networks_advanced {
      name        = docker_network.node_exporter.id
      aliases     = []
      driver_opts = []
    }

    container_spec {
      image = "docker.io/prom/node-exporter:v1.7.0@sha256:4cb2b9019f1757be8482419002cb7afe028fdba35d47958829e4cfeaf6246d80"

      args = [
        "--path.procfs=/host/proc",
        "--path.sysfs=/host/sys",
        "--path.rootfs=/host/rootfs",
        "--collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($|/)",
        "--collector.filesystem.ignored-fs-types=^(autofs|proc|sysfs|tmpfs|devtmpfs|devpts|overlay|aufs)$",
      ]

      mounts {
        target    = "/host/proc"
        source    = "/proc"
        type      = "bind"
        read_only = true
      }

      mounts {
        target    = "/host/sys"
        source    = "/sys"
        type      = "bind"
        read_only = true
      }

      mounts {
        target    = "/host/rootfs"
        source    = "/"
        type      = "bind"
        read_only = true
      }

      mounts {
        target    = "/etc/host_hostname"
        source    = "/etc/hostname"
        type      = "bind"
        read_only = true
      }
    }
  }

  mode {
    global = true
  }

  endpoint_spec {
    ports {
      target_port    = 9100
      published_port = 9100
      publish_mode   = "ingress"
    }
  }
}

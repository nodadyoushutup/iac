locals {
  casc_config_yaml = yamlencode(var.casc_config)
  casc_config_sha  = sha256(local.casc_config_yaml)
  casc_config      = var.casc_config
  mounts           = var.mounts
}

resource "docker_volume" "controller" {
  name = "jenkins-controller"
}

resource "docker_volume" "controller_nfs" {
  for_each = { for mount in local.mounts : mount.name => mount }

  name        = each.value.name
  driver      = lookup(each.value, "driver", "local")
  driver_opts = lookup(each.value, "driver_opts", {})
}

resource "docker_config" "casc_config" {
  name = "jenkins.yaml"
  data = base64encode(local.casc_config_yaml)
}

resource "docker_service" "controller" {
  name = "jenkins-controller"
  depends_on = [ docker_config.casc_config, docker_volume.controller, docker_volume.controller_nfs ]

  task_spec {
    container_spec {
      image = "ghcr.io/nodadyoushutup/jenkins-controller:0.0.7@sha256:055d6ea796cb7bc04e76617732542e5ee721e6742ee7722a622f367243f68336"

      env = {
        CASC_JENKINS_CONFIG = "/home/jenkins/jenkins.yaml"
        SECRETS_DIR = "/home/jenkins/.jenkins"
      }

      mounts {
        target = "/home/jenkins"
        source = docker_volume.controller.name
        type   = "volume"
      }

      mounts {
        target = "/dev/kvm"
        source = "/dev/kvm"
        type   = "bind"
      }

      dynamic "mounts" {
        for_each = { for mount in local.mounts : mount.name => mount }
        content {
          target = mounts.value.target
          source = docker_volume.controller_nfs[mounts.value.name].name
          type   = "volume"

          volume_options {
            no_copy = lookup(mounts.value, "no_copy", false)
          }
        }
      }

      configs {
        config_id   = docker_config.casc_config.id
        config_name = docker_config.casc_config.name
        file_name   = "/home/jenkins/jenkins.yaml"
      }

      healthcheck {
        test         = ["CMD", "curl", "-fsS", "http://127.0.0.1:8080/whoAmI/api/json?tree=authenticated"]
        interval     = "10s"
        timeout      = "5s"
        retries      = 30
        start_period = "1m"
      }
    }

    placement {
      platforms {
        os           = "linux"
        architecture = "arm64"
      }
    }
  }

  endpoint_spec {
    ports {
      target_port    = 8080
      published_port = 8080
      publish_mode   = "ingress"
    }

    ports {
      target_port    = 50000
      published_port = 50000
      publish_mode   = "ingress"
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
  }
}

resource "null_resource" "wait_for_service" {
  depends_on = [docker_service.controller]

  provisioner "local-exec" {
    command = "MAX_ATTEMPTS=${var.healthcheck_max_attempts} TIMEOUT=${var.healthcheck_timeout_seconds} bash ${path.module}/healthcheck.sh ${var.healthcheck_endpoint} ${var.healthcheck_delay_seconds}"
  }
}

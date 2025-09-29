locals {
  casc_config = merge(
    var.casc_config,
    {
      jenkins = merge(
        try(var.casc_config.jenkins, {}),
        {
          crumbIssuer = try(var.casc_config.jenkins.crumbIssuer, {
            standard = {
              excludeClientIPFromCrumb = true
            }
          })
        }
      )
    }
  )
}

resource "docker_volume" "controller" {
  name = var.controller_name
}

resource "docker_config" "casc_config" {
  name = var.casc_config_name
  data = base64encode(yamlencode(local.casc_config))
}

resource "docker_service" "controller" {
  name = var.controller_name

  task_spec {
    container_spec {
      image = "ghcr.io/nodadyoushutup/jenkins-controller:0.0.5@sha256:bfa7ddc0b93ec2c75fe469450f2d89764f3b61f0dad6b4adb92ef028c3e65bf9"

      env = {
        JAVA_OPTS           = "-Djenkins.install.runSetupWizard=false"
        CASC_JENKINS_CONFIG = "/jenkins/casc_configs"
      }

      mounts {
        target = "/var/jenkins_home"
        source = docker_volume.controller.name
        type   = "volume"
      }

      mounts {
        target = "/dev/kvm"
        source = "/dev/kvm"
        type   = "bind"
      }

      mounts {
        target = "/var/jenkins_home/.jenkins"
        source = pathexpand("~/.jenkins")
        type   = "bind"
      }

      mounts {
        target = "/var/jenkins_home/.ssh"
        source = pathexpand("~/.ssh")
        type   = "bind"
      }

      # mounts {
      #   target = "/var/jenkins_home/.kube"
      #   source = pathexpand("~/.kube")
      #   type   = "bind"
      # }

      mounts {
        target = "/var/jenkins_home/.tfvars"
        source = pathexpand("~/.tfvars")
        type   = "bind"
      }

      configs {
        config_id   = docker_config.casc_config.id
        config_name = docker_config.casc_config.name
        file_name   = "/jenkins/casc_configs/config.yaml"
      }

      dns_config {
        nameservers = var.dns_nameservers
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
      # Docker rewrites placement.platforms on apply; ignore the noise while nodes stay arm64.
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

locals {
  casc_config_yaml = yamlencode(var.casc_config)
  casc_config_sha  = sha256(local.casc_config_yaml)
  casc_config      = var.casc_config
}

resource "docker_volume" "controller" {
  name = var.controller_name
}

resource "docker_volume" "controller_nfs_jenkins" {
  name   = "${var.controller_name}-nfs-jenkins"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.jenkins"
  }
}

resource "docker_volume" "controller_nfs_ssh" {
  name   = "${var.controller_name}-nfs-ssh"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.ssh"
  }
}

resource "docker_volume" "controller_nfs_kube" {
  name   = "${var.controller_name}-nfs-kube"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.kube"
  }
}

resource "docker_volume" "controller_nfs_tfvars" {
  name   = "${var.controller_name}-nfs-tfvars"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.tfvars"
  }
}

resource "docker_config" "casc_config" {
  name = "jenkins.yaml"
  data = base64encode(local.casc_config_yaml)
}

resource "docker_service" "controller" {
  depends_on = [
    docker_config.casc_config,
    docker_volume.controller,
    docker_volume.controller_nfs_jenkins,
    docker_volume.controller_nfs_ssh,
    docker_volume.controller_nfs_kube,
    docker_volume.controller_nfs_tfvars,
  ]
  name = var.controller_name

  task_spec {
    container_spec {
      image = "ghcr.io/nodadyoushutup/jenkins-controller:0.0.6@sha256:2d0e2ca1bc160bfc16e3e690d77ab7bfca3f733fdef78801e4c9f2660ef082f5"

      env = {
        CASC_JENKINS_CONFIG = "/var/jenkins_home/jenkins.yaml"
        SECRETS_DIR         = "/var/jenkins_home/.jenkins"
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
        source = docker_volume.controller_nfs_jenkins.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      mounts {
        target = "/var/jenkins_home/.ssh"
        source = docker_volume.controller_nfs_ssh.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      mounts {
        target = "/var/jenkins_home/.kube"
        source = docker_volume.controller_nfs_kube.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      mounts {
        target = "/var/jenkins_home/.tfvars"
        source = docker_volume.controller_nfs_tfvars.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      configs {
        config_id   = docker_config.casc_config.id
        config_name = docker_config.casc_config.name
        file_name   = "/var/jenkins_home/jenkins.yaml"
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

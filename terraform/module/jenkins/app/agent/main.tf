locals {
  mounts = [
    for mount in var.mounts : merge(mount, {
      name = startswith(mount.name, "jenkins-") ? replace(mount.name, "jenkins-", format("jenkins-agent-%s-", var.name)) : format("%s-agent-%s", mount.name, var.name)
    })
  ]
}

resource "docker_volume" "agent" {
  name = "jenkins-agent-${var.name}"
}

resource "docker_volume" "agent_nfs" {
  for_each = { for mount in local.mounts : mount.name => mount }

  name        = each.value.name
  driver      = lookup(each.value, "driver", "local")
  driver_opts = lookup(each.value, "driver_opts", {})
}

resource "terraform_data" "controller_service" {
  input = var.controller_service_id
}

resource "docker_service" "agent" {
  name = "jenkins-agent-${var.name}"
  depends_on = [
    docker_volume.agent,
    docker_volume.agent_nfs,
    terraform_data.controller_service
  ]

  task_spec {
    container_spec {
      image = "ghcr.io/nodadyoushutup/jenkins-agent:0.0.6@sha256:2107336d4738aafa59606b2b8463231fddc255965cb3983e9015b53c56e6ab0d"

      env = merge(
        var.env,
        {
          JENKINS_URL        = try(var.provider_config.jenkins.server_url, "")
          JENKINS_AGENT_NAME = var.name
        }
      )

      mounts {
        target = "/home/jenkins"
        source = docker_volume.agent.name
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
          source = docker_volume.agent_nfs[mounts.key].name
          type   = "volume"

          volume_options {
            no_copy = lookup(mounts.value, "no_copy", false)
          }
        }
      }
    }

    placement {
      platforms {
        os           = "linux"
        architecture = "arm64"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
    replace_triggered_by = [
      terraform_data.controller_service
    ]
  }
}

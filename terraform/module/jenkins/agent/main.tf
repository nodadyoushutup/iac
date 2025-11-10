locals {
  mounts = [
    for mount in var.mounts : merge(mount, {
      name = format(
        "%s-%s",
        startswith(mount.name, "jenkins-") ? replace(mount.name, "jenkins-", format("jenkins-agent-%s-", var.name)) : format("%s-agent-%s", mount.name, var.name),
        substr(sha256(jsonencode({
          driver      = mount.driver
          driver_opts = mount.driver_opts
          target      = mount.target
          no_copy     = mount.no_copy
        })), 0, 8)
      )
    })
  ]
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

resource "docker_volume" "agent" {
  name = format(
    "jenkins-agent-%s-%s",
    var.name,
    substr(sha256(var.controller_service_id), 0, 8)
  )
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

resource "terraform_data" "controller_image" {
  input = var.controller_image
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
      image = "ghcr.io/nodadyoushutup/jenkins-agent:0.0.7@sha256:932b7568a2847b5a0545525e961b6073384ff76bcc3f40b08bd3c339c6ab9f69"

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
            driver_name    = mounts.value.driver
            driver_options = mounts.value.driver_opts
            no_copy        = mounts.value.no_copy
          }
        }
      }
    }

    placement {
      dynamic "platforms" {
        for_each = local.allowed_platforms

        content {
          os           = platforms.value.os
          architecture = platforms.value.architecture
        }
      }
      constraints = ["node.labels.role==cicd"]
    }
  }

  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
    replace_triggered_by = [
      terraform_data.controller_service,
      terraform_data.controller_image
    ]
  }
}

resource "docker_volume" "agent" {
  name = "jenkins-agent-${var.name}"
}

resource "docker_volume" "agent_nfs_jenkins" {
  name   = "jenkins-agent-${var.name}-nfs-jenkins"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.jenkins"
  }
}

resource "docker_volume" "agent_nfs_ssh" {
  name   = "jenkins-agent-${var.name}-nfs-ssh"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.ssh"
  }
}

resource "docker_volume" "agent_nfs_tfvars" {
  name   = "jenkins-agent-${var.name}-nfs-tfvars"
  driver = "local"
  driver_opts = {
    type   = "nfs"
    o      = "addr=192.168.1.100,nolock,hard,rw"
    device = ":/mnt/eapp/skel/.tfvars"
  }
}

resource "docker_service" "agent" {
  name = "jenkins-agent-${var.name}"

  task_spec {
    container_spec {
      image = "ghcr.io/nodadyoushutup/jenkins-agent:0.0.4@241d266cb7eecbb8619e23ef1bbabd3bb23c73d926ff721e8785ccc845c5af2a"

      env = {
        JENKINS_URL        = var.jenkins_url
        JENKINS_AGENT_NAME = var.name
      }

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

      mounts {
        target = "/home/jenkins/.jenkins"
        source = docker_volume.agent_nfs_jenkins.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      mounts {
        target = "/home/jenkins/.ssh"
        source = docker_volume.agent_nfs_ssh.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      # mounts {
      #   target = "/home/jenkins/.kube"
      #   source = pathexpand("~/.kube")
      #   type   = "bind"
      # }

      mounts {
        target = "/home/jenkins/.tfvars"
        source = docker_volume.agent_nfs_tfvars.name
        type   = "volume"
        volume_options {
          no_copy = true
        }
      }

      dns_config {
        nameservers = ["1.1.1.1", "8.8.8.8"]
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
      # Docker rewrites placement.platforms on apply; ignore the noise while nodes stay arm64.
      task_spec[0].placement[0].platforms,
    ]
  }
}

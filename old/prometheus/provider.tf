terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }

    backend "s3" {
        key = "prometheus.tfstate"
    }
}

provider "docker" {
    host = "ssh://${local.config.machine.global.username}@${local.config.machine.required.docker.ipv4.address}:22"
    ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-o", "IdentityFile=${var.SSH_PRIVATE_KEY}"]
}
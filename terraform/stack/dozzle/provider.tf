terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }

    backend "s3" {
        key = "dozzle.tfstate"
    }
}

provider "docker" {
    host = "ssh://${var.machine.global.user}@${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:22"
    ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-o", "IdentityFile=${var.SSH_PRIVATE_KEY}"]
}
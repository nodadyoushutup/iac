terraform {
    required_providers {
        proxmox = {
            source = "bpg/proxmox"
        }
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }
        grafana = {
            source  = "grafana/grafana"
            version = "3.18.3"
        }
    }

    backend "s3" {
        bucket = var.MINIO_BUCKET_TERRAFORM
        key = "terraform.tfstate"
        endpoint = var.MINIO_ENDPOINT
        access_key = var.MINIO_ACCESS_KEY
        secret_key = var.MINIO_SECRET_KEY
        region = var.MINIO_REGION
        skip_credentials_validation = true
        skip_metadata_api_check = true
        skip_region_validation = true
        force_path_style = true
    }
}

provider "proxmox" {
  endpoint = var.PROXMOX_VE_ENDPOINT
  password = var.PROXMOX_VE_PASSWORD
  username = var.PROXMOX_VE_USERNAME
  random_vm_ids = true
  insecure = true
  ssh {
    agent = true
    # agent_socket = 1022
    username = var.PROXMOX_VE_SSH_USERNAME
    private_key = file(var.SSH_PRIVATE_KEY)
    node {
      name    = var.PROXMOX_VE_SSH_NODE_NAME
      address = var.PROXMOX_VE_SSH_NODE_ADDRESS
    }
  }
}

provider "docker" {
    host = "ssh://${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}@${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:22"
    ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-o", "IdentityFile=${var.SSH_PRIVATE_KEY}"]
}

provider "grafana" {
    url  = "http://${var.VIRTUAL_MACHINE_DOCKER_IP_ADDRESS}:3000"
    auth = "grafana:grafana"
    insecure_skip_verify = true
}
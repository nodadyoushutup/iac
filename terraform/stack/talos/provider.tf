terraform {
    required_providers {
        talos = {
            source  = "siderolabs/talos"
            version = "0.7.1"
        }
    }

    backend "s3" {
      key = "proxmox.tfstate"
    }
}

provider "talos" {}
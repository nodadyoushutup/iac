terraform {
  # required_providers {
  #   proxmox = {
  #     source = "bpg/proxmox"
  #   }
  # }

  backend "s3" {
    key = "proxmox.tfstate"
  }
}

data "terraform_remote_state" "config" {
  backend = "s3"

  config = {
    bucket                      = "config"
    key                         = "config.tfstate"
    region                      = "us-east-1"
    access_key                  = var.access_key
    secret_key                  = var.secret_key
    endpoint                    = var.endpoints.s3
    skip_credentials_validation = var.skip_credentials_validation
    skip_metadata_api_check     = var.skip_metadata_api_check
    skip_region_validation      = var.skip_region_validation
    skip_requesting_account_id  = var.skip_requesting_account_id
    use_path_style              = var.use_path_style
  }
}

output "previous_config" {
  value = data.terraform_remote_state.config.outputs.config
}

# provider "proxmox" {
#   endpoint = var.terraform.proxmox.endpoint
#   password = var.terraform.proxmox.password
#   username = var.terraform.proxmox.username
#   random_vm_ids = true
#   insecure = true
#   ssh {
#     agent = true
#     # agent_socket = 1022
#     username = var.terraform.proxmox.ssh.username
#     private_key = file(var.ssh_private_key)
#     node {
#       name = var.terraform.proxmox.ssh.node.name
#       address = var.terraform.proxmox.ssh.node.address
#     }
#   }
# }
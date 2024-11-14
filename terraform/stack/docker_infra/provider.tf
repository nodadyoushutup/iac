# terraform {
#   required_providers {
#     proxmox = {
#       source = "bpg/proxmox"
#     }
#   }
# }

# provider "proxmox" {
#   endpoint = local.config.spacelift.provider.proxmox.endpoint
#   insecure  = local.config.spacelift.provider.proxmox.insecure
#   username = local.config.spacelift.provider.proxmox.username
#   password = local.config.spacelift.provider.proxmox.password
#   ssh {
#     private_key = file(local.config.spacelift.private_key)
#     node {
#       name = local.config.spacelift.provider.proxmox.ssh.node.name
#       address = local.config.spacelift.provider.proxmox.ssh.node.address
#       port = local.config.spacelift.provider.proxmox.ssh.node.port
#     }
#   }
# }

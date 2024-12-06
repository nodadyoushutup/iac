# terraform {
#   required_providers {
#     proxmox = {
#       source = "bpg/proxmox"
#     }
#   }
# }

# provider "proxmox" {
#   endpoint = "${local.config.dataproxmox.endpoint.protocol}://${local.config.dataproxmox.endpoint.ip_address}:${local.config.dataproxmox.endpoint.port}"
#   insecure  = local.config.dataproxmox.endpoint.insecure
#   password = local.config.dataproxmox.auth.password
#   username = "${local.config.dataproxmox.auth.username}@${local.config.dataproxmox.auth.realm}"
#   ssh {
#     agent = local.config.dataproxmox.ssh.agent.enabled
#     agent_socket = local.config.dataproxmox.ssh.agent.socket
#     private_key = coalesce(try(file(local.config.dataproxmox.ssh.private_key), null), var.PATH_PRIVATE_KEY)
#     node {
#       name = local.config.dataproxmox.ssh.node.name
#       address = local.config.dataproxmox.ssh.node.address
#       port = local.config.dataproxmox.ssh.node.port
#     }
#   }
# }
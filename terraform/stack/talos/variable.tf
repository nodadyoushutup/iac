variable "PATH_CONFIG" {
  type = string
  description = "Configuration path"
  default = "/mnt/workspace/config.yaml"
}

variable "PATH_PRIVATE_KEY" {
  type = string
  description = "Private key"
  default = "/mnt/workspace/id_rsa"
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

# variable "node_data" {
#   description = "A map of node data"
#   type = object({
#     controlplanes = map(object({
#       install_disk = string
#       hostname     = optional(string)
#     }))
#     workers = map(object({
#       install_disk = string
#       hostname     = optional(string)
#     }))
#   })
#   default = {
#     controlplanes = {
#       "${local.config.talos.ip_address}:${local.config.talos.control_plane[0].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-cp-0"
#       },
#       "${local.config.talos.ip_address}:${local.config.talos.control_plane[1].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-cp-1"
#       },
#       "${local.config.talos.ip_address}:${local.config.talos.control_plane[2].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-cp-1"
#       }
#     }
#     workers = {
#       "${local.config.talos.ip_address}:${local.config.talos.worker[0].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-wk-0"
#       },
#       "${local.config.talos.ip_address}:${local.config.talos.worker[1].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-wk-1"
#       }
#       "${local.config.talos.ip_address}:${local.config.talos.worker[2].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-wk-2"
#       }
#       "${local.config.talos.ip_address}:${local.config.talos.worker[3].port}" = {
#         install_disk = "/dev/sda"
#         hostname = "talos-wk-3"
#       }
#     }
#   }
# }
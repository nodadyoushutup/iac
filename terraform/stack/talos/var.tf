variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
        "192.168.1.200" = {
            install_disk = "/dev/sda"
            hostname = "talos-cp-1"
        },
        "192.168.1.201" = {
            install_disk = "/dev/sda"
            hostname = "talos-cp-2"
        },
        "192.168.1.202" = {
            install_disk = "/dev/sda"
            hostname = "talos-cp-3"
        }
    }
    workers = {
        "192.168.1.203" = {
            install_disk = "/dev/sda"
            hostname = "talos-wk-1"
        },
    }
  }
}
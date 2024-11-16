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
        hostname = "talos-cp-0"
      },
      "192.168.1.201" = {
        install_disk = "/dev/sda"
        hostname = "talos-cp-1"
      },
      "192.168.1.202" = {
        install_disk = "/dev/sda"
        hostname = "talos-cp-1"
      }
    }
    workers = {
      "192.168.1.203" = {
        install_disk = "/dev/sda"
        hostname = "talos-wk-0"
      },
      "192.168.1.204" = {
        install_disk = "/dev/sda"
        hostname = "talos-wk-1"
      }
      "192.168.1.205" = {
        install_disk = "/dev/sda"
        hostname = "talos-wk-2"
      }
      "192.168.1.206" = {
        install_disk = "/dev/sda"
        hostname = "talos-wk-3"
      }
    }
  }
}
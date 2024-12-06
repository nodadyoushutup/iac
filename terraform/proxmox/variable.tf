variable "CONFIG_PATH_CONFIG" {
  type = string
  description = "Configuration path"
  default = "/mnt/workspace/source/terraform/spacelift/config/config.yaml"
}

variable "CONFIG_PATH_PUBLIC_KEY" {
  type = string
  description = "Public SSH keys directory"
  default = "/mnt/workspace/"
}

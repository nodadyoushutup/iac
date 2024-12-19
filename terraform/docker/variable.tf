variable "CONFIG_PATH_CONFIG" {
  type = string
  description = "Configuration path"
  default = "/mnt/workspace/source/terraform/spacelift/config/config.yaml"
}

variable "DEFAULT_PRIVATE_KEY" {
  type = string
  description = "Default private key"
  default = "/mnt/workspace/id_rsa"
}

variable "DEFAULT_PUBLIC_KEY_DIR" {
  type = string
  description = "Public SSH keys directory"
  default = "/mnt/workspace/"
}

variable "DEFAULT_USERNAME" {
  type = string
  description = "Default username"
  default = null
}

variable "DEFAULT_PASSWORD" {
  type = string
  description = "Default password"
  default = null
}

variable "DEFAULT_IP_ADDRESS" {
  type = string
  description = "Default IP Address"
  default = null
}
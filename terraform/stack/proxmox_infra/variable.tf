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
variable "CONFIG_PATH" {
  type = string
  description = "Configuration path"
  default = null
}

variable "FLAG_DEPLOY" {
  type = number
  description = "Deployment ID"
  default = 0
}

variable "FLAG_VALID_CONFIG" {
  type = number
  description = "Spacelift valid configuration flag"
  default = 0
}

variable "DEFAULT_PRIVATE_KEY" {
  type = string
  description = "Default private key"
  default = "/mnt/workspace/id_rsa"
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

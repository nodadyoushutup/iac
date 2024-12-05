

# variable "FLAG_PYVENV" {
#   type = number
#   description = "Python virtual envrionment flag"
#   default = 0
# }

# variable "FLAG_CONFIG" {
#   type = number
#   description = "Spacelift configuration flag"
#   default = 0
# }

# variable "FLAG_DEPLOY" {
#   type = number
#   description = "Deployment ID"
#   default = 0
# }

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

variable "GITHUB_BRANCH" {
  type = string
  description = "Environment branch"
  default = null
}

variable "GITHUB_REPOSITORY" {
  type = string
  description = "Environment repository"
  default = null
}

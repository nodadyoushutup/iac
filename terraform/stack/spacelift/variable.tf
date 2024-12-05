

# variable "PATH_CONFIG" {
#     type = string
#     description = "Configuration path"
#     default = "/mnt/workspace/config.yaml"
# }

# variable "PATH_PRIVATE_KEY" {
#   type = string
#   description = "Private key"
#   default = "/mnt/workspace/id_rsa"
# }

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

variable "PROXMOX_VE_USERNAME" {
  type = string
  description = "Proxmox username"
  default = null
}
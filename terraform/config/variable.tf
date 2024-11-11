variable "BRANCH" {
    type = string
    description = "Environment branch"
    default = null
}

variable "CONFIG_PATH" {
    type = string
    description = "Configuration path"
    default = "/mnt/workspace/config.yaml"
}

variable "REPOSITORY" {
    type = string
    description = "Environment repository"
    default = null
}

variable "PRIVATE_KEY" {
  type = string
  description = "Private key"
  default = "/mnt/workspace/id_rsa"
}

variable "PYVENV" {
  type = number
  description = "Python virtual envrionment"
  default = 0
}
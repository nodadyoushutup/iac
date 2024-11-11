variable "BRANCH" {
    type = string
    description = "Environment branch"
    default = "main"
}

variable "CONFIG_PATH" {
    type = string
    description = "Configuration path"
    default = "/mnt/workspace/config.yaml"
}

variable "REPOSITORY" {
    type = string
    description = "Environment repository"
    default = "iac"
}

variable "PRIVATE_KEY" {
  type = string
  description = "Private key"
  default = "/mnt/workspace/id_rsa"
}

variable "PYVENV" {
  type = bool
  description = "Python virtual envrionment"
  default = true
}
variable "GIT_BRANCH" {
    type = string
    description = "Environment branch"
    default = null
}

variable "GIT_REPOSITORY" {
    type = string
    description = "Environment repository"
    default = null
}

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

variable "FLAG_PYVENV" {
  type = number
  description = "Python virtual envrionment flag"
  default = 0
}

variable "FLAG_CONFIG" {
  type = number
  description = "Spacelift configuration flag"
  default = 0
}
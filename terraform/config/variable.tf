variable "CONFIG_PATH" {
    type = string
    description = "Configuration path"
    default = "/mnt/workspace/config.yaml"
}

variable "ENV_BRANCH" {
    type = string
    description = "Environment branch"
    default = null
}

variable "ENV_REPOSITORY" {
    type = string
    description = "Environment repository"
    default = null
}

variable "PRIVATE_KEY" {
  type = string
  description = "Private key"
  default = "/mnt/workspace/ird_rsa"
}
variable "CONFIG_PATH" {
    type = string
    description = "Configuration path"
    default = "/mnt/workspace/config.yaml"
}

variable "ENV_BRANCH" {
    type = string
    description = "Environment branch"
    default = "main"
}

variable "ENV_REPOSITORY" {
    type = string
    description = "Environment repository"
    default = "iac"
}

variable "PRIVATE_KEY" {
  type = string
  description = "Private key"
  default = "/mnt/workspace/id_rsa"
}
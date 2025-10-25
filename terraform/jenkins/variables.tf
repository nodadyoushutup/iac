variable "provider_config" {
  description = "Configuration for the Docker provider"
  type        = any
}

variable "casc_config" {
  description = "Configuration for Jenkins"
  type        = any
}

variable "mounts" {
  description = "Mount definitions shared between the Jenkins controller and agents"
  type = list(object({
    name        = string
    target      = string
    driver      = string
    driver_opts = map(string)
    no_copy     = bool
  }))
}

variable "env" {
  description = "Environment variables applied to both the Jenkins controller and agents"
  type        = map(string)
  default = {
    SECRETS_DIR = "/home/jenkins/.jenkins"
  }
}

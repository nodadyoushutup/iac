variable "provider_config" {
  description = "Configuration for the Docker provider"
  type        = any
}

variable "casc_config" {
  description = "Configuration for Jenkins"
  type        = any
}

variable "mounts" {
  description = "Mount definitions for Jenkins controller volumes"
  type = list(object({
    name        = string
    target      = string
    driver      = string
    driver_opts = map(string)
    no_copy     = bool
  }))
}

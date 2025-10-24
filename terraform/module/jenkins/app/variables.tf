variable "casc_config" {
  description = "Configuration as Code payload for the Jenkins controller"
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

variable "provider_config" {
  description = "Provider configuration shared across Jenkins components"
  type        = any
}

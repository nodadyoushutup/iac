variable "casc_config" {
  description = "Configuration as Code payload for the Jenkins controller"
  type        = any
}

variable "healthcheck_endpoint" {
  description = "Endpoint used to verify the Jenkins controller is healthy"
  type        = string
}

variable "jenkins_url" {
  description = "URL of the Jenkins controller"
  type        = string
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

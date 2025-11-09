variable "casc_config" {
  description = "Configuration as Code data structure for the Jenkins controller"
  type        = any
}

variable "mounts" {
  description = "Mount definitions used to provision NFS-backed volumes for the controller"
  type = list(object({
    name        = string
    target      = string
    driver      = string
    driver_opts = map(string)
    no_copy     = bool
  }))
}

variable "provider_config" {
  description = "Provider configuration shared across Jenkins resources"
  type        = any
}

variable "env" {
  description = "Additional environment variables to inject into the Jenkins controller task definition"
  type        = map(string)
  default     = {}
}

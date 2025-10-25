variable "name" {
  description = "Name of the Jenkins agent"
  type        = string
}

variable "provider_config" {
  description = "Provider configuration shared across Jenkins resources"
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

variable "controller_service_id" {
  description = "Swarm service ID for the Jenkins controller; changes force agent replacement"
  type        = string
}

variable "env" {
  description = "Environment variables shared with each Jenkins agent container"
  type        = map(string)
  default     = {}
}

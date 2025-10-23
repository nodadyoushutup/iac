variable "casc_config" {
  description = "Configuration as Code data structure for the Jenkins controller"
  type        = any
}

variable "healthcheck_endpoint" {
  description = "Endpoint used by the local healthcheck script to verify the controller is online"
  type        = string
}

variable "healthcheck_delay_seconds" {
  description = "Delay between healthcheck attempts"
  type        = number
  default     = 5
}

variable "healthcheck_max_attempts" {
  description = "Maximum number of healthcheck attempts"
  type        = number
  default     = 60
}

variable "healthcheck_timeout_seconds" {
  description = "Timeout for each healthcheck attempt"
  type        = number
  default     = 5
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

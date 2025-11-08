variable "provider_config" {
  description = "Configuration map passed to the Docker provider"
  type        = any
}

variable "prometheus_config" {
  description = "Structured Prometheus configuration rendered into docker_config"
  type        = any
}

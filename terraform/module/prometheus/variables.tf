variable "provider_config" {
  description = "Docker provider configuration"
  type        = any
}

variable "prometheus_config" {
  description = "Structured Prometheus configuration that gets rendered to YAML"
  type        = any
}

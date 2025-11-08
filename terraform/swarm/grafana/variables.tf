variable "provider_config" {
  description = "Provider configuration map (docker host + Grafana auth hints)"
  type        = any
}

variable "grafana_config_inputs" {
  description = "Grafana provider configuration data (datasources, dashboards, folders)"
  type        = any
  default     = {}
}

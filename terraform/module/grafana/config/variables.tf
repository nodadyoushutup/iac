variable "grafana_config_inputs" {
  description = "Structured Grafana configuration definitions (folders, data sources, dashboards)."
  type        = any
  default     = {}
}

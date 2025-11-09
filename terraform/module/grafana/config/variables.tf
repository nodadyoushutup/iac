variable "grafana_config_inputs" {
  description = "Structured Grafana configuration definitions (folders, data sources, dashboards)."
  type        = any
  default     = {}
}

variable "folders" {
  description = "Optional list of extra Grafana folders to provision."
  type        = list(any)
  default     = []
}

variable "datasources" {
  description = "Optional list of Grafana data sources to manage."
  type        = list(any)
  default     = []
}

variable "dashboards" {
  description = "Optional list of Grafana dashboards to manage."
  type        = list(any)
  default     = []
}

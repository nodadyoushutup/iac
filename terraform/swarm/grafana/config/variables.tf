variable "provider_config" {
  description = "Provider configuration map (grafana credentials + optional docker host)"
  type        = any
}

variable "grafana_config_inputs" {
  description = "Grafana provider configuration data (datasources, dashboards, folders)"
  type        = any
  default     = {}
}

variable "folders" {
  description = "Optional list of additional Grafana folders to manage"
  type        = list(any)
  default     = []
}

variable "datasources" {
  description = "Optional list of Grafana data sources to manage"
  type        = list(any)
  default     = []
}

variable "dashboards" {
  description = "Optional list of Grafana dashboards to manage"
  type        = list(any)
  default     = []
}

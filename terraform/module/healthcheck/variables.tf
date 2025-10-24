variable "endpoint" {
  description = "Endpoint to probe for health"
  type        = string
}

variable "delay_seconds" {
  description = "Delay between healthcheck attempts"
  type        = number
  default     = 5
}

variable "max_attempts" {
  description = "Maximum number of healthcheck attempts"
  type        = number
  default     = 60
}

variable "timeout_seconds" {
  description = "Timeout for each healthcheck attempt"
  type        = number
  default     = 5
}

variable "status_range" {
  description = "HTTP status code range that is considered healthy"
  type        = string
  default     = "200-399"
}

variable "curl_insecure" {
  description = "Allow insecure TLS connections when probing HTTPS endpoints"
  type        = bool
  default     = false
}

variable "quiet" {
  description = "Suppress progress logging from the healthcheck script"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Additional environment variables passed to the healthcheck script"
  type        = map(string)
  default     = {}
}

variable "triggers" {
  description = "Additional triggers forcing the null resource to re-run when values change"
  type        = map(string)
  default     = {}
}

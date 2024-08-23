variable "component" {
  type = string
  description = "Component"
}

variable "github_enterprise" {
  type = string
  description = "Github Enterprise account"
  default = null
}

variable "repository" {
  description = "Repository URL for the Spacelift stack."
  type        = string
  default     = null
}
variable "folder_name" {
  description = "Name of the Jenkins folder to manage"
  type        = string
}

variable "enabled" {
  description = "Toggle to enable or disable Jenkins configuration resources"
  type        = bool
  default     = true
}

variable "config" {
    type = any
}

variable "agent" {
  description = "agent"
  type = object({
    enabled = optional(bool, true)
    timeout = optional(string, "25m")
    trim = optional(bool, false)
    type = optional(string, "virtio")
  })
  default = null
}
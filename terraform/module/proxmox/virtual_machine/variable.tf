variable "config" {
    type = any
}

variable "agent" {
  description = "agent"
  type = object({
    enabled = optional(bool, true)
    timeout = optional(string, "15m")
    trim = optional(bool, false)
    type = optional(string, "virtio")
  })
  default = {}
}

variable "audio_device" {
    description = "audio_device"
    type = object({
        device  = optional(string, "intel-hda")
        driver  = optional(string, "spice")
        enabled = optional(bool, true)
    })
    default = {}
}
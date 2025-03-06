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

variable "bios" {
  type = string
  default = "ovmf"
}

variable "boot_order" {
  type = list(string)
  default = ["scsi0"]
}

variable "cpu" {
  description = "cpu"
  type = object({
    affinity = optional(string, null)
    cores = optional(number, 2)
    flags = optional(list(string), ["+aes"])
    hotplugged = optional(number, 0)
    limit = optional(number, 0)
    numa = optional(bool, false)
    sockets = optional(number, 1)
    type = optional(string, "x86-64-v2-AES")
    units = optional(number, 1024)
  })
  default = {}
}

variable "description" {
  type = string
  default = null
}

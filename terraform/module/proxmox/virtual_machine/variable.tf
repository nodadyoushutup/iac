variable "config" {
  type = any
}

variable "cloud_init" {
  description = "Cloud-init configuration for this VM"
  type        = any
  default     = {}
}

variable "agent" {
  description = "agent"
  type = object({
    enabled = optional(bool)
    timeout = optional(string)
    trim = optional(bool)
    type = optional(string)
  })
  default = {}
}

variable "audio_device" {
  description = "audio_device"
  type = object({
    device  = optional(string)
    driver  = optional(string)
    enabled = optional(bool)
  })
  default = null
}

variable "bios" {
  type    = string
  default = null
}

variable "boot_order" {
  type = list(string)
  default = null
}

variable "cpu" {
  description = "cpu"
  type = object({
    affinity = optional(string)
    cores = optional(number)
    flags = optional(list(string))
    hotplugged = optional(number)
    limit = optional(number)
    numa = optional(bool)
    sockets = optional(number)
    type = optional(string)
    units = optional(number)
  })
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "disk" {
  description = "disk"
  type = object({
    aio = optional(string)
    backup = optional(bool)
    cache = optional(string)
    datastore_id = optional(string)
    discard = optional(string)
    file_format = optional(string)
    file_id = optional(string)
    interface = optional(string)
    iothread = optional(bool)
    replicate = optional(bool)
    serial = optional(string)
    size = optional(number)
    ssd = optional(bool)
  })
  default = null
}

variable "machine" {
  type    = string
  default = "q35"
}

variable "memory" {
  description = "memory"
  type = object({
    dedicated = optional(number, 4096)
    floating  = optional(number, 0)
    shared    = optional(number, 0)
  })
  default = {}
}

variable "network_device" {
  description = "network_device"
  type = object({
    bridge       = optional(string, "vmbr0")
    disconnected = optional(bool, false)
    enabled      = optional(bool, true)
    firewall     = optional(bool, false)
    mac_address  = optional(string, null)
    model        = optional(string, "virtio")
  })
  default = {}
}

variable "node_name" {
  type    = string
  default = "pve"
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "operating_system" {
  description = "operating_system"
  type = object({
    type = optional(string, "l26")
  })
  default = {}
}

variable "started" {
  type    = bool
  default = true
}

variable "startup" {
  description = "startup"
  type = object({
    order      = optional(number, 1)
    up_delay   = optional(number, 0)
    down_delay = optional(number, 0)
  })
  default = {}
}

variable "tags" {
  type    = list(string)
  default = ["terraform"]
}

variable "stop_on_destroy" {
  type    = bool
  default = true
}

variable "vga" {
  description = "vga"
  type = object({
    memory    = optional(number, 16)
    type      = optional(string, "qxl")
    clipboard = optional(string, "vnc")
  })
  default = {}
}

variable "vm_id" {
  type    = number
  default = null
}

variable "name" {
  type    = string
  default = null
}
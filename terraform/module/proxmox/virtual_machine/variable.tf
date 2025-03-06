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

variable "disk" {
  description = "disk"
  type = object({
    aio = optional(string, "io_uring")
    backup = optional(bool, true)
    cache = optional(string, "none")
    datastore_id = optional(string, "virtualization")
    discard = optional(string, "on")
    file_id = optional(string, null) #TODO
    file_format = optional(string, "raw")
    interface = optional(string, "scsi0")
    iothread = optional(bool, false)
    replicate = optional(bool, true)
    serial = optional(string, null)
    size = optional(number, 20)
    ssd = optional(bool, true)
  })
  default = {}
}

variable "machine" {
  type = string
  default = "q35"
}

variable "memory" {
  description = "memory"
  type = object({
    dedicated = optional(number, 4096)
    floating = optional(number, 0)
    shared = optional(number, 0)
  })
  default = {}
}

variable "network_device" {
  description = "network_device"
  type = object({
    bridge = optional(string, "vmbr0")
    disconnected = optional(bool, false)
    enabled = optional(bool, true)
    firewall = optional(bool, false)
    mac_address = optional(string, null)
    model = optional(string, "virtio")
  })
  default = {}
}


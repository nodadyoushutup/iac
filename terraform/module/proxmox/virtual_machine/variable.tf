variable "PATH_CONFIG" {
  type = string
  description = "Terraform configuration path"
  default = null
}

# REQUIRED
variable "node_name" {
  type = string
  description = "Proxmox Node Name"
}

# OPTIONAL
variable "acpi" {
  type = bool
  description = "Enable ACPI"
  default = null
}

variable "agent" {
  type = object({
    enabled = optional(bool)
    timeout = optional(string)
    trim = optional(bool)
    type = optional(string)
  })
  description = "QEMU agent configuration"
  default = null
}

variable "audio_device" {
  type = object({
    device = optional(string)
    driver = optional(string)
    enabled = optional(bool)
  })
  description = "Audio device"
  default = null
}

variable "bios" {
  type = string
  description = "BIOS implementation"
  default = null
}

variable "boot_order" {
  type = list(string)
  description = "Devices to boot from"
  default = null
}

variable "cdrom" {
  type = object({
    enabled = optional(bool)
    file_id = optional(string)
    interface = optional(string)
  })
  description = "Audio device"
  default = null
}

variable "clone" {
  type = object({
    datastore_id = optional(string)
    node_name = optional(string)
    retries = optional(number)
    vm_id = number
    full = optional(bool)
  })
  description = "Cloning configuration"
  default = null
}

variable "cpu" {
  type = object({
    architecture = optional(string)
    cores = optional(number)
    flags = optional(list(string))
    hotplugged = optional(number)
    limit = optional(number)
    numa = optional(bool)
    sockets = optional(number)
    type = optional(string)
    units = optional(number)
    affinity = optional(string)
  })
  description = "CPU configuration"
  default = null
}


























variable "name" {
  type = string
  description = "Virtual machine name"
  default = null
}

variable "stop_on_destroy" {
  type = bool
  description = "Force stop on destroy"
  default = true
}

variable "vm_id" {
  type = number
  description = "Virtual machine ID"
  default = null
}



variable "cpu" {
  type = object({
    cores = number
    type = string
  })
  description = "CPU"
  default = null
}

variable "memory" {
  type = object({
    dedicated = number
  })
  description = "Memory"
  default = null
}

variable "disk" {
  type = object({
    datastore_id = string
    file_id = string
    interface = string
    discard = string
    size = string
  })
  description = "Disk"
  default = null
}

variable "network_device" {
  type = object({
    bridge = string
    mac_address = string
  })
  description = "Network device"
  default = null
}
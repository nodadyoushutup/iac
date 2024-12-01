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

variable "description" {
  type = string
  description = "Description"
  default = null
}

variable "disk" {
  type = object({
    aio = optional(string)
    backup = optional(bool)
    cache = optional(string)
    datastore_id = optional(string)
    path_in_datastore = optional(string)
    discard = optional(string)
    file_format = optional(string)
    file_id = optional(string)
    interface = string
    iothread = optional(bool)
    replicate = optional(bool)
    serial = optional(string)
    size = optional(number)
    speed = optional(object({
      iops_read = optional(number)
      iops_read_burstable = optional(number)
      iops_write = optional(number)
      iops_write_burstable = optional(number)
      read = optional(number)
      read_burstable = optional(number)
      write = optional(number)
      write_burstable = optional(number)
    }))
    ssd = optional(bool)
  })
  description = "Disk"
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

variable "memory" {
  type = object({
    dedicated = number
  })
  description = "Memory"
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
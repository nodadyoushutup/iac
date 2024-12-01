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
  default = true
}

variable "agent" {
  type = object({
    enabled = optional(bool, false)
    timeout = optional(string, "15m")
    trim = optional(bool, false)
    type = optional(string, "virtio")
  })
  description = "Agent"
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
# modules/proxmox/virtual_machine/variable.tf

variable "vm_id" {
  description = "The ID of the virtual machine."
  type        = number
}

variable "name" {
  description = "The name of the virtual machine."
  type        = string
  default     = "ubuntu"
}

variable "description" {
  description = "A description of the virtual machine."
  type        = string
  default     = "Virtual machine"
}

variable "tags" {
  description = "Tags associated with the virtual machine."
  type        = list(string)
  default     = ["terraform", "ubuntu"]
}

variable "node_name" {
  description = "The name of the Proxmox node where the VM will run."
  type        = string
  default     = "pve"
}

variable "on_boot" {
  description = "Whether the VM should start on boot."
  type        = bool
  default     = true
}

variable "started" {
  description = "Whether the VM should be started after creation."
  type        = bool
  default     = true
}

variable "stop_on_destroy" {
  description = "Whether the VM should be stopped when Terraform destroys the resource."
  type        = bool
  default     = true
}

variable "boot_order" {
  description = "The boot order of the virtual machine's disks."
  type        = list(string)
  default     = ["scsi0"]
}

variable "disk" {
  description = "Configuration for the VM's disk."
  type = object({
    datastore_id = optional(string, "local-lvm")
    file_id      = optional(string, "local:iso/jammy-server-cloudimg-amd64.img")
    interface    = optional(string, "scsi0")
    size         = optional(number, 10)
  })
  default = {}
}

variable "memory" {
  description = "Memory configuration for the VM."
  type = object({
    dedicated = optional(number, 4096)
  })
  default = {}
}

variable "cpu" {
  description = "CPU configuration for the VM."
  type = object({
    sockets = optional(number, 1)
    cores   = optional(number, 2)
  })
  default = {}
}

variable "initialization" {
  description = "Initialization configuration for the VM."
  type = object({
    ip_config = optional(object({
      ipv4 = optional(object({
        address = optional(string, "dhcp")
        gateway = optional(string, null)
      }), {})
      ipv6 = optional(object({
        address = optional(string, "dhcp")
        gateway = optional(string, null)
      }), {})
    }), {})
    user_account = optional(object({
      username = optional(string, "ubuntu")
      password = optional(string, "ubuntu")
      keys = optional(list(string), [])
    }), {})
  })
  default = {}
}

variable "network_device" {
  description = "CPU configuration for the VM."
  type = object({
    bridge = optional(string, "vmbr0")
    model   = optional(string, "e1000e")
  })
  default = {}
}
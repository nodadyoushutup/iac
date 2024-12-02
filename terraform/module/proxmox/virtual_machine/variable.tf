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
  description = "Disk configuration"
  default = null
}

variable "efi_disk" {
  type = object({
    datastore_id = optional(string)
    file_format = optional(string)
    type = optional(string)
    pre_enrolled_keys = optional(bool)
  })
  description = "EFI disk configuration"
  default = null
}

variable "tpm_state" {
  type = object({
    datastore_id = optional(string)
    version = optional(string)
  })
  description = "TPM state device"
  default = null
}

variable "hostpci" {
  type = object({
    device = string
    id = optional(string)
    mapping = optional(string)
    mdev = optional(string)
    pcie = optional(bool)
    rombar = optional(bool)
    rom_file = optional(string)
    xvga = optional(bool)
  })
  description = "PCI device mapping"
  default = null
}

variable "usb" {
  type = object({
    host = optional(string)
    mapping = optional(string)
    usb3 = optional(bool)
  })
  description = "USB device mapping"
  default = null
}

variable "initialization" {
  type = object({
    datastore_id = optional(string)
    interface = optional(bool)
    dns = optional(object({
      domain = optional(string)
      server = optional(string)
      servers = optional(string)
    }))
    ip_config = optional(object({
      ipv4 = optional(object({
        address = optional(string)
        gateway = optional(string)
      }))
      ipv6 = optional(object({
        address = optional(string)
        gateway = optional(string)
      }))
    }))
    user_account = optional(object({
      keys = optional(list(string))
      password = optional(string)
      username = optional(string)
    }))
    network_data_file_id = optional(string)
    user_data_file_id = optional(string)
    vendor_data_file_id = optional(string)
    meta_data_file_id = optional(string)
  })
  description = "Initialization configuration"
  default = null
}

variable "keyboard_layout" {
  type = string
  description = "keyboard layout"
  default = null
}

variable "kvm_arguments" {
  type = string
  description = "Arbitrary arguments passed to kvm"
  default = null
}

variable "machine" {
  type = string
  description = "Machine type"
  default = null
}

variable "memory" {
  type = object({
    dedicated = optional(number)
    floating = optional(number)
    shared = optional(number)
    hugepages = optional(string)
    keep_hugepages = optional(bool)
  })
  description = "Memory configuration"
  default = null
}

# TODO: NUMA configuration

variable "migrate" {
  type = bool
  description = "Migrate the VM on node change instead of re-creating it"
  default = null
}

variable "name" {
  type = string
  description = "Virtual machine name"
  default = null
}

variable "network_device" {
  type = object({
    bridge = optional(string)
    disconnected = optional(bool)
    enabled = optional(bool)
    firewall = optional(bool)
    mac_address = optional(string)
    model = optional(string)
    mtu = optional(number)
    queues = optional(number)
    rate_limit = optional(number)
    vlan_id = optional(number)
    trunks = optional(string)
  })
  description = "Network device"
  default = null
}

variable "on_boot" {
  type = bool
  description = "Started during system boot"
  default = null
}

variable "operating_system" {
  description = "Operating System configuration"
  type = object({
    type = optional(string)
  })
  default = null
}

variable "pool_id" {
  type = string
  description = "Pool to assign"
  default = null
}

variable "protection" {
  type = bool
  description = "Disable the remove VM and remove disk operations"
  default = null
}

variable "reboot" {
  type = bool
  description = "Reboot after initial creation"
  default = null
}

variable "serial_device" {
  description = "Serial device"
  type = object({
    device = optional(string)
  })
  default = null
}

variable "scsi_hardware" {
  type = string
  description = "SCSI hardware type"
  default = null
}

variable "smbios" {
  description = "SMBIOS (type1) configuration"
  type = object({
    family = optional(string)
    manufacturer = optional(string)
    product = optional(string)
    serial = optional(string)
    sku = optional(string)
    uuid = optional(string)
    version = optional(string)
  })
  default = null
}

variable "started" {
  type = bool
  description = "Start the virtual machine"
  default = null
}

variable "startup" {
  description = "Startup and shutdown behavior"
  type = object({
    order = optional(number)
    up_delay = optional(number)
    down_delay = optional(number)
  })
  default = null
}

variable "tablet_device" {
  type = bool
  description = "Enable the USB tablet device"
  default = null
}

variable "tags" {
  type = list(string)
  description = "Tags"
  default = null
}

variable "template" {
  type = bool
  description = "Create a template"
  default = null
}

variable "stop_on_destroy" {
  type = bool
  description = "Force stop on destroy"
  default = null
}

variable "timeout_clone" {
  type = number
  description = "Timeout for cloning a VM in seconds"
  default = null
}

variable "timeout_create" {
  type = number
  description = "Timeout for creating a VM in seconds"
  default = null
}

variable "timeout_migrate" {
  type = number
  description = "Timeout for migrating the VM in seconds"
  default = null
}

variable "timeout_reboot" {
  type = number
  description = "Timeout for rebooting a VM in seconds"
  default = null
}

variable "timeout_shutdown_vm" {
  type = number
  description = "Timeout for shutting down a VM in seconds"
  default = null
}

variable "timeout_start_vm" {
  type = number
  description = "Timeout for starting a VM in seconds"
  default = null
}

variable "timeout_stop_vm" {
  type = number
  description = "Timeout for stopping a VM in seconds"
  default = null
}

variable "vga" {
  description = "VGA configuration"
  type = object({
    memory = optional(number)
    type = optional(string)
    clipboard = optional(string)
  })
  default = null
}








variable "vm_id" {
  type = number
  description = "Virtual machine ID"
  default = null
}














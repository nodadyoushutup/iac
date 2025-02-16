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
    default = {}
}

variable "bios" {
    description = "bios"
    type = string
    default = "ovmf"
}

variable "boot_order" {
    description = "boot_order"
    type = list(string)
    default = ["scsi0"]
}

variable "cpu" {
    description = "cpu"
    type = object({
        cores = optional(number, 2)
        flags = optional(list(string), ["+aes"])
        hotplugged = optional(number, 0)
        limit = optional(number, 0)
        numa = optional(bool, false)
        sockets = optional(number, 1)
        type = optional(string, "x86-64-v2-AES")
        units = optional(number, 1024)
        affinity = optional(string, null)
    })
    default = {}
}

variable "description" {
    description = "description"
    type = string
    default = "Virtual machine"
}

variable "disk" {
    description = "disk"
    type = object({
        aio = optional(string, "io_uring")
        backup = optional(bool, true)
        cache = optional(string, "none")
        datastore_id = optional(string, "virtualization")
        discard = optional(string, "on")
        file_id = optional(string, "local:iso/cloud-image-x86-64-jammy-0.1.13.img")
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

variable "efi_disk" {
    description = "efi_disk"
    type = object({
        datastore_id = optional(string, "virtualization")
        file_format = optional(string, "raw")
        type = optional(string, "4m")
        pre_enrolled_keys = optional(bool, false)
    })
    default = {}
}

variable "initialization" {
    description = "initialization"
    type = object({
        datastore_id = optional(string, "virtualization")
        user_data_file_id = optional(string, "local:snippets/cloud-config.yaml")
        ip_config = optional(object({
            ipv4 = optional(object({
                address = optional(string, "dhcp")
                gateway = optional(string, "192.168.1.1")
                cidr = optional(number, 24)
            }), {})
            ipv6 = optional(object({
                address = optional(string, "dhcp")
                gateway = optional(string, null)
            }), {})
        }), {})
    })
    default = {}
}

variable "machine" {
    description = "machine"
    type = string
    default = "q35"
}

variable "memory" {
    description = "memory"
    type = object({
        dedicated = optional(number, 2048)
        floating = optional(number, 0)
        shared = optional(number, 0)
    })
    default = {}
}

variable "name" {
    description = "name"
    type = string
}

variable "node_name" {
    description = "node_name"
    type = string
    default = "pve"
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

variable "on_boot" {
    description = "on_boot"
    type = bool
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
    description = "started"
    type = bool
    default = true
}

variable "startup" {
    description = "startup"
    type = object({
        order = optional(number, 1)
        up_delay = optional(number, 0)
        down_delay = optional(number, 0)
    })
    default = {}
}

variable "tags" {
    description = "tags"
    type = list(string)
    default = ["gitops"]
}

variable "stop_on_destroy" {
    description = "stop_on_destroy"
    type = bool
    default = true
}

variable "vga" {
    description = "vga"
    type = object({
        memory = optional(number, 16)
        type = optional(string, "qxl")
        clipboard = optional(string, "vnc")
    })
    default = {}
}

variable "vm_id" {
    description = "vm_id"
    type = number
    default = null
}

variable "cloud_config" {
    description = "Git configuration"
    type = object({
        hostname = optional(string, null)
        datastore_id = optional(string, "local")
        node_name = optional(string, "pve")
        auth = optional(object({
            github  = optional(string, null)
            username = optional(string, "nodadyoushutup")
            ssh_public_key = optional(list(string), [])
        }), {})
        runcmd = optional(list(string), [])
    })
    default = {}
}

variable "image" {
    description = "Image configuration"
    type = object({
        datastore_id = optional(string, "local")
        node_name = optional(string, "pve")
        file_name = optional(string, null)
        url = optional(string, "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img")
    })
    default = {}
}
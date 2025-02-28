variable "config" {
  type = any
}

# variable "cloud_config" {
#     description = "Git configuration"
#     type = object({
#         hostname = optional(string)
#         datastore_id = optional(string)
#         node_name = optional(string)
#         runcmd = optional(list(string))
#         auth = optional(object({
#             github = optional(string)
#             username = optional(string)
#             ssh_public_key = optional(list(string))
#         }), {})
        
#     })
#     default = null
# }

# variable "image" {
#     description = "Image configuration"
#     type = object({
#         datastore_id = optional(string)
#         node_name = optional(string)
#         file_name = optional(string)
#         url = optional(string)
#     })
#     default = null
# }

variable "agent" {
    description = "agent"
    type = object({
        enabled = optional(bool)
        timeout = optional(string)
        trim = optional(bool)
        type = optional(string)
    })
    default = null
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
    description = "bios"
    type = string
    default = null
}

variable "boot_order" {
    description = "boot_order"
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
    description = "description"
    type = string
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
        file_id = optional(string)
        file_format = optional(string)
        interface = optional(string)
        iothread = optional(bool)
        replicate = optional(bool)
        serial = optional(string)
        size = optional(number)
        ssd = optional(bool)
    })
    default = null
}

variable "efi_disk" {
    description = "efi_disk"
    type = object({
        datastore_id = optional(string)
        file_format = optional(string)
        type = optional(string)
        pre_enrolled_keys = optional(bool)
    })
    default = null
}

variable "initialization" {
    description = "initialization"
    type = object({
        datastore_id = optional(string)
        user_data_file_id = optional(string)
        ip_config = optional(object({
            ipv4 = optional(object({
                address = optional(string)
                cidr = optional(number)
                gateway = optional(string)
            }), {})
            ipv6 = optional(object({
                address = optional(string)
                gateway = optional(string)
            }), {})
        }), {})
    })
    default = null
}

variable "machine" {
    description = "machine"
    type = string
    default = null
}

variable "memory" {
    description = "memory"
    type = object({
        dedicated = optional(number)
        floating = optional(number)
        shared = optional(number)
    })
    default = {}
}

variable "name" {
    description = "name"
    type = string
    default = null
}

variable "node_name" {
    description = "node_name"
    type = string
    default = null
}

variable "network_device" {
    description = "network_device"
    type = object({
        bridge = optional(string)
        disconnected = optional(bool)
        enabled = optional(bool)
        firewall = optional(bool)
        mac_address = optional(string)
        model = optional(string)
    })
    default = null
}

variable "on_boot" {
    description = "on_boot"
    type = bool
    default = null
}

variable "operating_system" {
    description = "operating_system"
    type = object({
        type = optional(string)
    })
    default = null
}

variable "started" {
    description = "started"
    type = bool
    default = null
}

variable "startup" {
    description = "startup"
    type = object({
        order = optional(number)
        up_delay = optional(number)
        down_delay = optional(number)
    })
    default = null
}

variable "tag" {
    description = "tags"
    type = list(string)
    default = null
}

variable "stop_on_destroy" {
    description = "stop_on_destroy"
    type = bool
    default = null
}

variable "vga" {
    description = "vga"
    type = object({
        memory = optional(number)
        type = optional(string)
        clipboard = optional(string)
    })
    default = null
}

variable "vm_id" {
    description = "vm_id"
    type = number
    default = null
}


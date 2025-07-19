# PROXMOX
variable "config" {
    type = any
}

variable "name" {
    type = string
}

variable "datastore_id" {
    type = string
    default = "local"
}

variable "node_name" {
    type = string
    default = "pve"
}

variable "overwrite" {
    type = bool
    default = true
}

# NETWORK

variable "ethernets" {
    type = map(object({
            match = optional(object({ 
                name = string 
            }))
            set_name = optional(string)
            dhcp4 = optional(bool)
            addresses = optional(list(string))
            gateway4 = optional(string)
            nameservers = optional(object({
            addresses = list(string)
        }))
    }))
    default = null
}

variable "bonds" {
    type = any
    default = null
}

variable "bridges" {
    type = any
    default = null
}

variable "vlans" {
    type = any
    default = null
}
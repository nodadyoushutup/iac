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


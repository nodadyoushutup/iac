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

variable "username" {
    type = string
    default = "nodadyoushutup"
}

variable "address" {
    type = string
    default = "dhcp"
}

variable "gateway" {
    type = string
    default = null
}

variable "overwrite" {
    type = bool
    default = true
}

variable "github" {
    type = string
    default = null
}
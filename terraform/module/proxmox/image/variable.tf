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

variable "url" {
    type = string
    default = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
}

variable "overwrite" {
    type = bool
    default = true
}

variable "overwrite_unmanaged" {
    type = bool
    default = true
}

variable "node_name" {
    type = string
    default = "pve"
}

variable "file_name" {
    type = string
    default = null
}
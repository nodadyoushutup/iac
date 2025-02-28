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
    default = null
}

variable "overwrite" {
    type = bool
    default = true
}

variable "overwrite_unmanaged" {
    type = bool
    default = true
}

variable "file_name" {
    type = string
    default = null
}
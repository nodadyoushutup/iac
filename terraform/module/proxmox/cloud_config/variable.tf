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

variable "gitconfig" {
    type = object({
        username = optional(string)
        email = optional(string)
    })
    default = null
}

variable "mounts" {
    type = list(list(string))
    default = null
}

variable "ipv4" {
    type = object({
        address = optional(string, "dhcp")
        gateway = optional(string)
    })
    default = null
}

variable "network" {
    description = "Cloud-init network configuration override"
    type = optional(object({
        version = optional(number, 2)
        ethernets = optional(object({
            eth0 = optional(object({
                match = optional(object({
                    name = optional(string, "en*")
                }))
                set-name = optional(string, "eth0")
                dhcp4 = optional(string, "yes")
                addresses = optional(list(string))
                gateway4 = optional(string)
                nameservers = optional(object({
                    addresses = optional(list(string))
                }))
            }))
        }))
    }))
    default     = null
}

# ######################################
variable "users" {
    # https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups
    description = "List of system users to configure"
    type = list(object({
        name = optional(string, "nodadyoushutup")
        doas = optional(list(string))
        expiredate = optional(string)
        gecos = optional(any) # string/array of string/objec
        groups = optional(any, ["sudo", "docker"]) # string/array of string/object
        homedir = optional(string)
        inactive = optional(string)
        lock_passwd = optional(bool)
        no_create_home = optional(bool)
        no_log_init = optional(bool)
        no_user_group = optional(bool)
        passwd = optional(string)
        hashed_passwd = optional(string)
        plain_text_passwd = optional(string)
        create_groups = optional(bool)
        primary_group = optional(string)
        selinux_user = optional(string)
        shell = optional(string, "/bin/bash")
        snapuser = optional(string)
        ssh_authorized_keys = optional(list(string))
        ssh_import_id = optional(list(string))
        ssh_redirect_user = optional(bool)
        system = optional(bool)
        sudo = optional(any, "ALL=(ALL) NOPASSWD:ALL")
        uid = optional(string)
    }))
    default = null
}

variable "groups" {
    # https://cloudinit.readthedocs.io/en/latest/reference/modules.html#users-and-groups
    type = list(string)
    default = null
}

variable "write_files" {
    # https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files
    description = "List of files to create"
    type = list(object({
        path        = optional(string)
        content     = optional(string)
        owner       = optional(string)
        permissions = optional(string)
        encoding    = optional(string, "b64")
        append      = optional(bool)
        defer       = optional(bool)
    }))
    default = null
}
variable "bootcmd" {
    # https://cloudinit.readthedocs.io/en/latest/reference/modules.html#bootcmd
    type = list(string)
    default = null
}

variable "runcmd" {
    # https://cloudinit.readthedocs.io/en/latest/reference/modules.html#runcmd
    type = list(string)
    default = null
}

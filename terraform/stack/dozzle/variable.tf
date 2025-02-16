# GIT
variable "GITHUB_USERNAME" {
    type = string
    default = null
}

variable "GIT_REPOSITORY_URL" {
    type = string
    default = null
}

variable "GIT_REPOSITORY_BRANCH" {
    type = string
    default = null
}

variable "GITCONFIG_NAME" {
    type = string
    default = null
}

variable "GITCONFIG_EMAIL" {
    type = string
    default = null
}

# GLOBAL
variable "SSH_PRIVATE_KEY" {
    type = string
    default = null
}

variable "PROXMOX_VE_CLOUD_IMAGE_URL" {
    type = string
    default = null
}

## GLOBAL
variable "VIRTUAL_MACHINE_GLOBAL_USERNAME" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_GLOBAL_GATEWAY" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_SNIPPET" {
    type = string
    default = null
}

variable "terraform" {
    description = "Terraform provider configurations"
    type = object({
        proxmox = object({
        endpoint = string
        password = string
        username = string
        ssh = object({
            username = string
            node = object({
                name = string
                address = string
            })
        })
        })
    })
}

variable "machine" {
    description = "Machine configuration"
    type = object({
        clickops = object({
            nas = object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                name = string
                network_device = object({
                    mac_address = string
                })
            })
            cicd = object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                name = string
                network_device = object({
                    mac_address = string
                })
            })
        })

        required = object({
            docker = object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                name = string
                network_device = object({
                    mac_address = string
                })
                cpu = object({
                    cores = number
                })
                memory = object({
                    dedicated = number
                })
                disk = object({
                    size = number
                })
                exec = list(string)
                vm_id = number
            })
            development = object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                name = string
                network_device = object({
                    mac_address = string
                })
                cpu = object({
                    cores = number
                })
                memory = object({
                    dedicated = number
                })
                disk = object({
                    size = number
                })
                exec = list(string)
                vm_id = number
            })
        })

        talos = object({
            name = string
            controlplane = list(object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                network_device = object({
                    mac_address = string
                })
                cpu = object({
                    cores = number
                })
                memory = object({
                    dedicated = number
                })
                disk = object({
                    size = number
                })
                vm_id = number
            }))
            worker = list(object({
                ipv4 = object({
                    address = string
                    gateway = string
                })
                network_device = object({
                    mac_address = string
                })
                cpu = object({
                    cores = number
                })
                memory = object({
                    dedicated = number
                })
                disk = object({
                    size = number
                })
                vm_id = number
            }))
        })

        global = object({
            agent = object({
                enabled = bool
                timeout = string
                trim = bool
                type = string
            })
            audio_device = object({
                device  = string
                driver  = string
                enabled = bool
            })
        })

        # custom = object({
        #     machine = object({
        #         ipv4 = object({
        #             address = string
        #             gateway = string
        #         })
        #         name = string
        #         network_device = object({
        #             mac_address = string
        #         })
        #         cpu = object({
        #             cores = number
        #         })
        #         memory = object({
        #             dedicated = number
        #         })
        #         disk = object({
        #             size = number
        #         })
        #         exec = list(string)
        #         vm_id = number
        #     })
        # })
    })
}


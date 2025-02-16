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

variable "SSH_PRIVATE_KEY" {
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
            datastore_id = object({
                disk = string
                iso = string
                snippet = string
            })
            image = object({
                cloud = object({
                    file_name = string
                    url = string
                })
                talos = object({
                    file_name = string
                    url = string
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
            username = string
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
            bios = string
            boot_order = list(string)
            cpu = object({
                cores = number
                flags = list(string)
                hotplugged = number
                limit = number
                numa = bool
                sockets = number
                type = string
                units = number
                # affinity = null
            })
            description = string
            disk = object({
                aio = string
                backup = bool
                cache = string
                # datastore_id = string
                discard = string
                file_format = string
                interface = string
                iothread = bool
                replicate = bool
                # serial = null
                size = number
                ssd = bool
            })
            efi_disk = object({
                file_format = string
                type = string
                pre_enrolled_keys = bool
            })
            ipv4 = object({
                address = string
                gateway = string
            })
            ipv6 = object({
                address = string
                # gateway = string
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


variable "SSH_PRIVATE_KEY" {
    type = string
    default = null
}

variable "git" {
    description = "Git configuration"
    type = object({
        github_username = string
        gitconfig = object({
            name = string
            email = string
        })
        repository = object({
            branch = string
            url = string
        })
    })
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

variable "jenkins" {
    description = "Jenkins configuration"
    type = object({
        endpoint = string
    })
}

variable "machine" {
    description = "Machine configuration"
    type = object({
        clickops = object({
            nas = object({
                name = string
                initialization = object({
                    ip_config = object({
                        ipv4 = object({
                            address = string
                            gateway = string
                        })
                    })
                })
            })
            cicd = object({
                name = string
                initialization = object({
                    ip_config = object({
                        ipv4 = object({
                            address = string
                            gateway = string
                        })
                    })
                })
            })
        })

        cloud = object({
            required = list(object({
                cloud_config = optional(object({
                    auth = optional(object({
                        github = optional(string, null)
                    }), {})
                }), {})
                image = optional(object({
                    url = optional(string, "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img")
                }), {})
                initialization = optional(object({
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
                }), {})
                name = optional(string, null)
                vm_id = optional(number, null)
            }))

            custom = list(object({
                name = string
                vm_id = optional(number, null)
                cloud_config = optional(object({
                    auth = optional(object({
                        github = optional(string, null)
                    }), {})
                }), {})
                image = optional(object({
                    url = optional(string, "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img")
                }), {})
                initialization = object({
                    ip_config = object({
                        ipv4 = object({
                            address = string
                            gateway = string
                        })
                    })
                })
            }))
        })

        talos = object({
            name = string
            controlplane = list(object({
                name = string
                vm_id = optional(number, null)
                image = optional(object({
                    url = optional(string, "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img")
                }), {})
                initialization = object({
                    ip_config = object({
                        ipv4 = object({
                            address = string
                            gateway = string
                        })
                    })
                })
            }))
            worker = list(object({
                name = string
                vm_id = optional(number, null)
                image = optional(object({
                    url = optional(string, "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img")
                }), {})
                initialization = object({
                    ip_config = object({
                        ipv4 = object({
                            address = string
                            gateway = string
                        })
                    })
                })
            }))
        })

        global = object({
            cloud_config = optional(object({
                auth = optional(object({
                    github = optional(string, null)
                }), {})
            }), {})
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
            initialization = object({
                ip_config = object({
                    ipv4 = object({
                        gateway = string
                    })
                })
            })
            machine = string
            memory = object({
                dedicated = number
                floating = number
                shared = number
            })
            name = string
            network_device = object({
                bridge = string
                disconnected = bool
                enabled = bool
                firewall = bool
                model = string
            })
            on_boot = bool
            operating_system = object({
                type = string
            })
            started = bool
            startup = object({
                order = number
                up_delay = number
                down_delay = number
            })
            tags = list(string)
            stop_on_destroy = bool
            vga = object({
                memory = number
                type = string
                clipboard = string
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

variable "bucket" {
    description = "MinIO bucket"
    type = string
}

variable "endpoints" {
    description = "MinIO endpoint"
    type = object({
        s3 = string
    })
}

variable "access_key" {
    description = "MinIO access key"
    type = string
}

variable "secret_key" {
    description = "MinIO access key"
    type = string
}

variable "region" {
    description = "MinIO access key"
    type = string
}

variable "skip_credentials_validation" {
    description = "MinIO access key"
    type = bool
}

variable "skip_metadata_api_check" {
    description = "MinIO access key"
    type = bool
}

variable "skip_region_validation" {
    description = "MinIO access key"
    type = bool
}

variable "use_path_style" {
    description = "MinIO access key"
    type = bool
}

variable "skip_requesting_account_id" {
    description = "MinIO access key"
    type = bool
}

provider "aws" {
    region = "us-east-1"   # MinIO requires a region (even if not used)
    access_key = var.access_key
    secret_key = var.secret_key
    skip_credentials_validation = var.skip_credentials_validation
    skip_metadata_api_check = var.skip_metadata_api_check
    skip_region_validation = var.skip_region_validation
    skip_requesting_account_id = var.skip_requesting_account_id
    endpoints {
        s3 = var.endpoints.s3
    }
}

data "aws_s3_object" "secret" {
    bucket = "terraform"
    key = "secret.tfvars"
}

output "secrets_content" {
    value = data.aws_s3_object.secret.body
}
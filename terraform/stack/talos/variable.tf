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

# MINIO
variable "MINIO_ENDPOINT" {
    type = string
    default = null
}

variable "MINIO_ACCESS_KEY" {
    type = string
    default = null
}

variable "MINIO_SECRET_KEY" {
    type = string
    default = null
}

variable "MINIO_BUCKET_TERRAFORM" {
    type = string
    default = null
}

variable "MINIO_REGION" {
    type = string
    default = null
}

# PROXMOX
variable "PROXMOX_VE_ENDPOINT" {
    type = string
    default = null
}

variable "PROXMOX_VE_PASSWORD" {
    type = string
    default = null
}

variable "PROXMOX_VE_USERNAME" {
    type = string
    default = null
}

variable "PROXMOX_VE_SSH_USERNAME" {
    type = string
    default = null
}

variable "PROXMOX_VE_SSH_NODE_ADDRESS" {
    type = string
    default = null
}

variable "PROXMOX_VE_SSH_NODE_NAME" {
    type = string
    default = null
}

variable "PROXMOX_VE_CLOUD_IMAGE_URL" {
    type = string
    default = null
}

# VIRTUAL MACHINE
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

## TRUENAS
variable "VIRTUAL_MACHINE_TRUENAS_NFS_MEDIA" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_TRUENAS_IP_ADDRESS" {
    type = string
    default = null
}

## DOCKER
variable "VIRTUAL_MACHINE_DOCKER_IP_ADDRESS" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_DOCKER_MAC_ADDRESS" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_DOCKER_VMID" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DOCKER_CPU_CORES" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DOCKER_MEMORY_DEDICATED" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DOCKER_DISK_SIZE" {
    type = number
    default = null
}

## DEVELOPMENT
variable "VIRTUAL_MACHINE_DEVELOPMENT_IP_ADDRESS" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_DEVELOPMENT_MAC_ADDRESS" {
    type = string
    default = null
}

variable "VIRTUAL_MACHINE_DEVELOPMENT_VMID" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DEVELOPMENT_CPU_CORES" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DEVELOPMENT_MEMORY_DEDICATED" {
    type = number
    default = null
}

variable "VIRTUAL_MACHINE_DEVELOPMENT_DISK_SIZE" {
    type = number
    default = null
}
variable "JENKINS_ENDPOINT" {
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
                    mac_address = string
                    gateway = string
                })
            })
            cicd = object({
                ipv4 = object({
                    address = string
                    mac_address = string
                    gateway = string
                })
            })
        })

        required = object({
            docker = object({
                ipv4 = object({
                    address = string
                    mac_address = string
                    gateway = string
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
            })
            development = object({
                ipv4 = object({
                    address = string
                    mac_address = string
                    gateway = string
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
            })
        })

        talos = object({
            controlplane = list(object({
                ipv4 = object({
                    address = string
                    mac_address = string
                    gateway = string
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
                    mac_address = string
                    gateway = string
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

        custom = optional(object({}))
        
        global = optional(object({}))
    })
}
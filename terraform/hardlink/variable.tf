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

variable "talos" {
  description = "Talos node configuration for controlplane and worker nodes."
    type = object({
        controlplane = list(object({
            ip_address  = string
            mac_address = string
            vm_id = number
            cores = number
            memory = number
        }))
        worker = list(object({
            ip_address = string
            mac_address = string
            vm_id = number
            cores = number
            memory = number
        }))
    })
  default = {
    controlplane = [
        {
            ip_address = "192.168.1.200"
            mac_address = "0a:00:00:00:12:00"
            vm_id = 1200
            cores = 4
            memory = 4096
        },
        {
            ip_address = "192.168.1.201"
            mac_address = "0a:00:00:00:12:01"
            vm_id = 1201
            cores = 4
            memory = 4096
        },
        {
            ip_address = "192.168.1.202"
            mac_address = "0a:00:00:00:12:02"
            vm_id = 1202
            cores = 4
            memory = 4096
        },
    ]
    worker = [
        {
            ip_address = "192.168.1.203"
            mac_address = "0a:00:00:00:12:03"
            vm_id = 1203
            cores = 4
            memory = 16384
        }
    ]
  }
}

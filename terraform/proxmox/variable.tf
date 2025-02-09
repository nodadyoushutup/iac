variable "SSH_PRIVATE_KEY" {
  type = string
  default = null
}

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

variable "VIRTUAL_MACHINE_USERNAME_GLOBAL" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_DATASTORE_ID_DISK" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_DATASTORE_ID_ISO" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_DATASTORE_ID_SNIPPET" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_IP_ADDRESS_DOCKER" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_IP_ADDRESS_DEVELOPMENT" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_IP_ADDRESS_TRUENAS" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_NFS_MEDIA" {
  type = string
  default = null
}

variable "VIRTUAL_MACHINE_VMID_DOCKER" {
  type = number
  default = null
}

variable "VIRTUAL_MACHINE_VMID_DEVELOPMENT" {
  type = number
  default = null
}

variable "GITHUB_USERNAME" {
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
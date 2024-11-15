packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type    = string
  default = "https://192.168.1.10:8006/api2/json"
}

variable "proxmox_username" {
  type    = string
  default = "root@pve"
}

variable "proxmox_password" {
  type    = string
  default = "S#nvhs89vher"
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
}

source "proxmox-iso" "ubuntu-cloud" {
  proxmox_url               = var.proxmox_url
  username                  = var.proxmox_username
  password                  = var.proxmox_password
  node                      = var.proxmox_node
  insecure_skip_tls_verify  = true

  cloud_init = true

  disks {
    disk_size         = "10G"
    storage_pool      = "local-lvm"
    type              = "scsi"
    format = "raw"
  }

  boot_iso {
    type                    = "scsi"
    # iso_url                 = "https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso"
    iso_file                = "local:iso/ubuntu-24.04.1-live-server-amd64.iso"
    unmount                 = true
    iso_checksum            = var.iso_checksum
    iso_storage_pool        = "local"
  }

  qemu_agent                = false

  ssh_username              = "ubuntu"
  ssh_password              = "ubuntu"
  ssh_timeout               = "20m"
}

build {
  sources = ["source.proxmox-iso.ubuntu-cloud"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
    ]
  }
}

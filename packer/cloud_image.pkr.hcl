packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

locals {
  local = {
    accelerator = "kvm"
    cd_file = ["./cloud-init/*"]
    script = [
      "./script/cloud-init.sh",
      "./script/install/apt.sh",
      "./script/install/docker.sh",
      "./script/cleanup.sh"
    ]
  }
  remote = {
    accelerator = "none"
    cd_files = ["packer/cloud-init/*"]
    scripts = [
      "packer/script/cloud-init.sh",
      "packer/script/install/apt.sh",
      "packer/script/install/docker.sh",
      "packer/script/cleanup.sh"
    ]
  }
}

variable "build_type" {
  type = string
  default = "local"
  description = "Build local or remote"
}

variable "ubuntu_version" {
  type        = string
  default     = "focal"
  description = "Ubuntu codename version"
}

source "qemu" "ubuntu" {
  accelerator      = var.build_type == "local" ? local.local.accelerator : local.remote.accelerator
  cd_files         = var.build_type == "local" ? local.local.cd_files : local.remote.cd_files
  cd_label         = "cidata"
  disk_compression = true
  disk_image       = true
  disk_size        = "10G"
  headless         = true
  iso_checksum     = "file:https://cloud-images.ubuntu.com/${var.ubuntu_version}/current/SHA256SUMS"
  iso_url          = "https://cloud-images.ubuntu.com/${var.ubuntu_version}/current/${var.ubuntu_version}-server-cloudimg-amd64.img"
  output_directory = "output-${var.ubuntu_version}"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_password     = "ubuntu"
  ssh_username     = "ubuntu"
  vm_name          = "nodadyoushutup-cloud-image-${var.ubuntu_version}.img"
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-serial", "mon:stdio"],
  ]
}

build {
  sources = ["source.qemu.ubuntu"]
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    scripts = var.build_type == "local" ? local.local.scripts : local.remote.scripts
  }
  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      version_fingerprint = packer.versionFingerprint
    }
  }
}

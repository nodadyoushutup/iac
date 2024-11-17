packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "ubuntu_version" {
  type        = string
  default     = "jammy"
  description = "Ubuntu codename version (i.e. 20.04 is focal and 22.04 is jammy)"
}

source "qemu" "ubuntu" {
  accelerator      = "none"
  cd_files         = ["packer/cloud-init/*"]
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
  vm_name          = "ubuntu-${var.ubuntu_version}.img"
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-serial", "mon:stdio"],
  ]
}

build {
  sources = ["source.qemu.ubuntu"]

  hcp_packer_registry {
    bucket_name = "cloud-image"
    description = "Cloud image"
    bucket_labels = {
      "cloud-image" = "cloud-image",
    }
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    scripts = [
      "packer/script/cloud-init.sh",
      "packer/script/install/apt.sh",
      "packer/script/install/docker.sh",
      "packer/script/cleanup.sh"
    ]
  }

  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      version_fingerprint = packer.versionFingerprint
    }
}

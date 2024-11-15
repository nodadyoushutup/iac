packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

# Define a Packer source image
source "qemu" "ubuntu" {
  iso_url       = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img"
  iso_checksum  = "sha256:3661899b29fc41da9873ecc1adbb95ab6600887cd0de077163e0720891645985"
  disk_size     = "10240"
  headless      = true
  format        = "qcow2"
  ssh_username  = "ubuntu"
  ssh_password  = "password"
}

# Define the build block that will use the source image
build {
  sources = ["source.qemu.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y qemu-guest-agent"
    ]
  }
}

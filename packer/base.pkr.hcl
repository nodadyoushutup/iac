packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "example" {
  iso_url           = "https://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud-1907.qcow2"
  iso_checksum      = "md5:5350c20875a3fec28157abbc7db5dc635911212804f892b751f94fcf3f285aec"
  output_directory  = "output_centos_tdhtest"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "5000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "path/to/httpdir"
  ssh_username      = "root"
  ssh_password      = "s0m3password"
  ssh_timeout       = "20m"
  vm_name           = "tdhtest"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "10s"
  boot_command      = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos6-ks.cfg<enter><wait>"]
}

build {
  sources = ["source.qemu.example"]
}

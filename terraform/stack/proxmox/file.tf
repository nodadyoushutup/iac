resource "proxmox_virtual_environment_download_file" "cloud" {
  content_type = "iso"
  datastore_id = var.terraform.proxmox.datastore_id.iso
  node_name = var.terraform.proxmox.ssh.node.name
  overwrite = true
  overwrite_unmanaged = true
  file_name = var.terraform.proxmox.image.cloud.file_name
  url = var.terraform.proxmox.image.cloud.url
}

resource "proxmox_virtual_environment_download_file" "talos" {
  content_type = "iso"
  datastore_id = var.terraform.proxmox.datastore_id.iso
  node_name = var.terraform.proxmox.ssh.node.name
  overwrite = true
  overwrite_unmanaged = true
  file_name = var.terraform.proxmox.image.talos.file_name
  url = var.terraform.proxmox.image.talos.url
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.terraform.proxmox.datastore_id.snippet
  node_name = var.terraform.proxmox.ssh.node.name

  source_raw {
    data = <<-EOF
    #cloud-config
    groups:
      - docker: [${var.machine.global.username}]
    users:
      - default
      - name: ${var.machine.global.username}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
      - su - ${var.machine.global.username} -c "ssh-import-id gh:${var.GITHUB_USERNAME}"
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}
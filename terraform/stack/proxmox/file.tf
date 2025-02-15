resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.terraform.proxmox.ssh.node.name
  overwrite = true
  overwrite_unmanaged = true
  url = var.PROXMOX_VE_CLOUD_IMAGE_URL
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.terraform.proxmox.ssh.node.name
  overwrite = true
  overwrite_unmanaged = true
  file_name = "talos-v1.9.3-metal-amd64.img"
  url = "https://factory.talos.dev/image/dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586/v1.9.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_SNIPPET
  node_name = var.terraform.proxmox.ssh.node.name

  source_raw {
    data = <<-EOF
    #cloud-config
    groups:
      - docker: [${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}]
    users:
      - default
      - name: ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
      - su - ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} -c "ssh-import-id gh:${var.GITHUB_USERNAME}"
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}
resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.12/cloud-image-x86-64-jammy-0.1.12.img"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.VIRTUAL_MACHINE_DATASTORE_ID_SNIPPET
  node_name = var.PROXMOX_VE_SSH_NODE_NAME

  source_raw {
    data = <<-EOF
    #cloud-config
    groups:
      - docker: [${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}]
    users:
      - default
      - name: ${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
    mounts:
      - ["${var.NAS_IP_ADDRESS}:${var.NAS_NFS_MEDIA}", "${var.NAS_NFS_MEDIA}", "nfs", "defaults,nofail", "0", "2"]
    runcmd:
      - su - ${var.VIRTUAL_MACHINE_USERNAME_GLOBAL} -c "ssh-import-id gh:${var.GITHUB_USERNAME}"
      - mkdir -p ${var.NAS_NFS_MEDIA}
      - chown ${var.VIRTUAL_MACHINE_USERNAME_GLOBAL}:${var.VIRTUAL_MACHINE_USERNAME_GLOBAL} ${var.NAS_NFS_MEDIA}
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}
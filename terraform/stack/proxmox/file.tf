resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  overwrite_unmanaged = true
  url = var.PROXMOX_VE_CLOUD_IMAGE_URL
}

resource "proxmox_virtual_environment_download_file" "talos_cp_1" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  overwrite_unmanaged = true
  file_name = "talos-cp-1-v1.9.3-metal-amd64.img"
  url = "https://factory.talos.dev/image/fd434a92ae30d326c078ae8b2283ecde3b9e17eb95adf759624f5f4098a5b597/v1.9.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "talos_cp_2" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  overwrite_unmanaged = true
  file_name = "talos-cp-2-v1.9.3-metal-amd64.img"
  url = "https://factory.talos.dev/image/e5b668b325eb94ccae097226c3b8d981393138ed4586e05370e224893c9a3d07/v1.9.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "talos_cp_3" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  overwrite_unmanaged = true
  file_name = "talos-cp-3-v1.9.3-metal-amd64.img"
  url = "https://factory.talos.dev/image/147f8d7596600487451158337e333300604087e30e5f9fa68149d421e45e238b/v1.9.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "talos_wk_1" {
  content_type = "iso"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO
  node_name = var.PROXMOX_VE_SSH_NODE_NAME
  overwrite = true
  overwrite_unmanaged = true
  file_name = "talos-wk-1-v1.9.3-metal-amd64.img"
  url = "https://factory.talos.dev/image/3b33bebae884868595a8297fce54e65c4b8d250bc8a7758187eea52744e28177/v1.9.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_SNIPPET
  node_name = var.PROXMOX_VE_SSH_NODE_NAME

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
    mounts:
      - ["${var.VIRTUAL_MACHINE_TRUENAS_IP_ADDRESS}:${var.VIRTUAL_MACHINE_TRUENAS_NFS_MEDIA}", "${var.VIRTUAL_MACHINE_TRUENAS_NFS_MEDIA}", "nfs", "defaults,nofail", "0", "2"]
    runcmd:
      - su - ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} -c "ssh-import-id gh:${var.GITHUB_USERNAME}"
      - mkdir -p ${var.VIRTUAL_MACHINE_TRUENAS_NFS_MEDIA}
      - chown ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}:${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} ${var.VIRTUAL_MACHINE_TRUENAS_NFS_MEDIA}
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}
resource "proxmox_virtual_environment_file" "cloud" {
    content_type = "snippets"
    datastore_id = "config"
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.type == "talos" ? local.template.talos : local.template.cloud
        file_name = "${local.name}-cloud-config.yaml"
    }
}

resource "proxmox_virtual_environment_file" "network" {
    content_type = "snippets"
    datastore_id = "config"
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.template.network
        file_name = "${local.name}-network-config.yaml"
    }
}


resource "proxmox_virtual_environment_download_file" "cloud" {
    content_type = "iso"
    datastore_id = "config"
    file_name = "${local.name}-cloud-image.img"
    node_name = local.node_name_computed
    url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
}


resource "proxmox_virtual_environment_vm" "virtual_machine" {
    name = "debug"
    node_name = local.node_name_computed
    vm_id = 1225
    stop_on_destroy = true
        
    cpu {
        cores = 2
        type = "x86-64-v2-AES"
    }

    memory {
        dedicated = 2048
    }

    disk {
        datastore_id = "virtualization"
        file_id = proxmox_virtual_environment_download_file.cloud.id
        interface = "scsi0"
        size = 50
    }

    initialization {
        datastore_id = "virtualization"
        user_data_file_id = proxmox_virtual_environment_file.cloud.id
        network_data_file_id = proxmox_virtual_environment_file.network.id
    }

    network_device {
        bridge = "vmbr0"
    }
}


output "debug" {
    value = local.template
}
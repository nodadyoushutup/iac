resource "proxmox_virtual_environment_file" "cloud" {
    content_type = "snippets"
    datastore_id = local.datastore_id_computed
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.type == "talos" ? local.template.talos : local.template.cloud
        file_name = "${local.name}-cloud-config.yaml"
    }
}

resource "proxmox_virtual_environment_file" "network" {
    content_type = "snippets"
    datastore_id = local.datastore_id_computed
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.template.network
        file_name = "${local.name}-network-config.yaml"
    }
}
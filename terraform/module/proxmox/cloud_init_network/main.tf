resource "proxmox_virtual_environment_file" "user_cloud_init" {
    content_type = "snippets"
    datastore_id = local.datastore_id_computed
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.template
        file_name = "${local.name}-user-cloud-init.yaml"
    }
}
# resource "proxmox_virtual_environment_file" "clout_init_network" {
#     content_type = "snippets"
#     datastore_id = local.datastore_id_computed
#     node_name = local.node_name_computed
#     overwrite = local.overwrite_computed

#     source_raw {
#         data = local.template.network
#         file_name = "${local.name}-clout-init-network.yaml"
#     }
# }
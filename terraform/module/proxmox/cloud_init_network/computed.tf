locals { # Computed
    # PROXMOX
    datastore_id_computed = local.datastore_id_input != null ? local.datastore_id_input : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_input != null ? local.node_name_input : local.node_name_global != null ? local.node_name_global : null
    overwrite_computed = local.overwrite_input != null ? local.overwrite_input : local.overwrite_global != null ? local.overwrite_global : null

    # NETWORK
    
}

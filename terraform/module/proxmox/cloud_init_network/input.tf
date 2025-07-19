locals { # Input
    # PROXMOX
    datastore_id_input = try(var.datastore_id, null)
    node_name_input = try(var.node_name, null)
    overwrite_input = try(var.overwrite, null)

    # NETWORK
    ethernets_input = try(var.ethernets, null)
    
}
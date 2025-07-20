locals { # Input
    # PROXMOX
    datastore_id_input = try(var.datastore_id, null)
    node_name_input = try(var.node_name, null)
    overwrite_input = try(var.overwrite, null)

    # NETWORK
    ethernets_input = try(var.ethernets, null)
    bonds_input     = try(var.bonds, null)
    bridges_input   = try(var.bridges, null)
    vlans_input     = try(var.vlans, null)
    
}
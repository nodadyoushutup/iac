locals { # Computed
    # PROXMOX
    datastore_id_computed = local.datastore_id_input != null ? local.datastore_id_input : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_input != null ? local.node_name_input : local.node_name_global != null ? local.node_name_global : null
    overwrite_computed = local.overwrite_input != null ? local.overwrite_input : local.overwrite_global != null ? local.overwrite_global : null

    # NETWORK
    ethernets_computed = local.ethernets_input != null ? {
        for name, cfg in local.ethernets_input :
        name => merge(local.ethernets_global != null ? local.ethernets_global : {}, cfg)
    } : local.ethernets_global

    bonds_computed   = local.bonds_input != null ? local.bonds_input : local.bonds_global
    bridges_computed = local.bridges_input != null ? local.bridges_input : local.bridges_global
    vlans_computed   = local.vlans_input != null ? local.vlans_input : local.vlans_global

    ethernets_clean = local.ethernets_computed != null ? {
        for n, cfg in local.ethernets_computed :
        n => { for k, v in cfg : k => v if v != null }
    } : null

    network_computed = merge(
        { version = 2 },
        local.ethernets_clean != null ? { ethernets = local.ethernets_clean } : {},
        local.bonds_computed != null ? { bonds = local.bonds_computed } : {},
        local.bridges_computed != null ? { bridges = local.bridges_computed } : {},
        local.vlans_computed != null ? { vlans = local.vlans_computed } : {}
    )
}

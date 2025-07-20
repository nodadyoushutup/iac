locals { # Global
    # PROXMOX
    datastore_id_global = try(var.config.proxmox.global.machine.cloud_config.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.machine.cloud_config.node_name, null)
    overwrite_global = try(var.config.proxmox.global.machine.cloud_config.overwrite, null)

    # NETWORK

    ethernets_global = try(var.config.proxmox.global.machine.cloud_config.ethernets, null)
    bonds_global     = try(var.config.proxmox.global.machine.cloud_config.bonds, null)
    bridges_global   = try(var.config.proxmox.global.machine.cloud_config.bridges, null)
    vlans_global     = try(var.config.proxmox.global.machine.cloud_config.vlans, null)
    
}

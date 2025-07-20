locals { # Global
    # PROXMOX
    datastore_id_global = try(var.config.proxmox.global.machine.cloud_init.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.machine.cloud_init.node_name, null)
    overwrite_global = try(var.config.proxmox.global.machine.cloud_init.overwrite, null)

    # NETWORK

    ethernets_global = try(var.config.proxmox.global.machine.cloud_init.ethernets, null)
    bonds_global     = try(var.config.proxmox.global.machine.cloud_init.bonds, null)
    bridges_global   = try(var.config.proxmox.global.machine.cloud_init.bridges, null)
    vlans_global     = try(var.config.proxmox.global.machine.cloud_init.vlans, null)
    
}

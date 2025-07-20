locals { # Global
    # PROXMOX
    datastore_id_global = try(var.config.proxmox.global.virtual_machine.cloud_init.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.virtual_machine.cloud_init.node_name, null)
    overwrite_global = try(var.config.proxmox.global.virtual_machine.cloud_init.overwrite, null)

    # USER
    users_global = try(var.config.proxmox.global.virtual_machine.cloud_init.users, null)
    mounts_global = try(var.config.proxmox.global.virtual_machine.cloud_init.mounts, null)
    groups_global = try(var.config.proxmox.global.virtual_machine.cloud_init.groups, null)
    write_files_global = try(var.config.proxmox.global.virtual_machine.cloud_init.write_files, null)
    bootcmd_global = try(var.config.proxmox.global.virtual_machine.cloud_init.bootcmd, null)
    runcmd_global = try(var.config.proxmox.global.virtual_machine.cloud_init.runcmd, null)
    gitconfig_global = {
        username = try(var.config.proxmox.global.virtual_machine.cloud_init.gitconfig.username, null)
        email = try(var.config.proxmox.global.virtual_machine.cloud_init.gitconfig.email, null)
        github_pat = try(var.config.proxmox.global.virtual_machine.cloud_init.gitconfig.github_pat, null)
    }
    
}
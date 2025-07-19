locals { # Global
    # PROXMOX
    datastore_id_global = try(var.config.proxmox.global.machine.cloud_config.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.machine.cloud_config.node_name, null)
    overwrite_global = try(var.config.proxmox.global.machine.cloud_config.overwrite, null)

    # USER
    users_global = try(var.config.proxmox.global.machine.cloud_config.users, null)
    mounts_global = try(var.config.proxmox.global.machine.cloud_config.mounts, null)
    groups_global = try(var.config.proxmox.global.machine.cloud_config.groups, null)
    write_files_global = try(var.config.proxmox.global.machine.cloud_config.write_files, null)
    bootcmd_global = try(var.config.proxmox.global.machine.cloud_config.bootcmd, null)
    runcmd_global = try(var.config.proxmox.global.machine.cloud_config.runcmd, null)
    gitconfig_global = {
        username = try(var.config.proxmox.global.machine.cloud_config.gitconfig.username, null)
        email = try(var.config.proxmox.global.machine.cloud_config.gitconfig.email, null)
        github_pat = try(var.config.proxmox.global.machine.cloud_config.gitconfig.github_pat, null)
    }
    
}
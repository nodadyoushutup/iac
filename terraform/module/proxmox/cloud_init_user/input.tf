locals { # Input
    # PROXMOX
    datastore_id_input = try(var.datastore_id, null)
    node_name_input = try(var.node_name, null)
    overwrite_input = try(var.overwrite, null)

    # NETWORK
    network_input = try(var.network, null)

    # USER
    users_input = try(var.users, null)
    mounts_input = try(var.mounts, null)
    groups_input = try(var.groups, null)
    write_files_input = try(var.write_files, null)
    bootcmd_input = try(var.bootcmd, null)
    runcmd_input = try(var.runcmd, null)
    gitconfig_input = {
        username = try(var.gitconfig.username, null)
        email = try(var.gitconfig.email, null)
        github_pat = try(var.gitconfig.github_pat, null)
    }
    
}
locals { # Computed
    # PROXMOX
    datastore_id_computed = local.datastore_id_input != null ? local.datastore_id_input : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_input != null ? local.node_name_input : local.node_name_global != null ? local.node_name_global : null
    overwrite_computed = local.overwrite_input != null ? local.overwrite_input : local.overwrite_global != null ? local.overwrite_global : null

    # USER
    users_computed = local.users_input != null ? local.users_input : local.users_global != null ? local.users_global : null
    mounts_computed = local.mounts_input != null ? local.mounts_input : local.mounts_global != null ? local.mounts_global : null
    groups_computed = local.groups_input != null ? local.groups_input : local.groups_global != null ? local.groups_global : null
    gitconfig_computed = {
        username = local.gitconfig_input.username != null ? local.gitconfig_input.username : local.gitconfig_global.username != null ? local.gitconfig_global.username : null
        email = local.gitconfig_input.email != null ? local.gitconfig_input.email : local.gitconfig_global.email != null ? local.gitconfig_global.email : null
        github_pat = local.gitconfig_input.github_pat != null ? local.gitconfig_input.github_pat : local.gitconfig_global.github_pat != null ? local.gitconfig_global.github_pat : null
    }
    bootcmd_computed = local.bootcmd_input != null ? local.bootcmd_input : local.bootcmd_global != null ? local.bootcmd_global : [] # Must be empty list to satisfy length() check in object
    runcmd_computed = local.runcmd_input != null ? local.runcmd_input : local.runcmd_global != null ? local.runcmd_global : [] # Must be empty list to satisfy length() check in object
    write_files_computed = local.write_files_input != null ? local.write_files_input : local.write_files_global != null ? local.write_files_global : null
}

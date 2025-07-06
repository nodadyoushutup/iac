locals { # Required
    name = var.name
}

locals { # Constant
    source = { 
        cloud = "${path.module}/template/cloud_config.yaml.tpl"
        talos = "${path.module}/template/talos_config.yaml.tpl"
        network = "${path.module}/template/network_config.yaml.tpl"
        gitconfig = "${path.module}/template/gitconfig.tpl"
    }
}
locals { # Variable
    datastore_id_variable = try(var.datastore_id, null)
    node_name_variable = try(var.node_name, null)
    overwrite_variable = try(var.overwrite, null)
    
    mounts_variable = try(var.mounts, null)
    ipv4_variable = {
        address = try(var.ipv4.address, null)
        gateway = try(var.ipv4.gateway, null)
    }

    # #############################
    users_variable = try(var.users, null)
    gitconfig_variable = {
        username = try(var.gitconfig.username, null)
        email = try(var.gitconfig.email, null)
        github_pat = try(var.gitconfig.github_pat, null)
    }
}

locals { # Global
    datastore_id_global = try(var.config.proxmox.global.machine.cloud_config.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.machine.cloud_config.node_name, null)
    overwrite_global = try(var.config.proxmox.global.machine.cloud_config.overwrite, null)
    
    mounts_global = try(var.config.proxmox.global.machine.cloud_config.mounts, null)
    ipv4_global = {
        address = try(var.config.proxmox.global.machine.cloud_config.ipv4.address, null)
        gateway = try(var.config.proxmox.global.machine.cloud_config.ipv4.gateway, null)
    }

    # ############################
    users_global = try(var.config.proxmox.global.machine.cloud_config.users, null)
    gitconfig_global = {
        username = try(var.config.proxmox.global.machine.cloud_config.github.username, null)
        email = try(var.config.proxmox.global.machine.cloud_config.github.email, null)
        github_pat = try(var.config.proxmox.global.machine.cloud_config.github.github_pat, null)
    }
}

locals { # Computed
    datastore_id_computed = local.datastore_id_variable != null ? local.datastore_id_variable : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_variable != null ? local.node_name_variable : local.node_name_global != null ? local.node_name_global : null
    overwrite_computed = local.overwrite_variable != null ? local.overwrite_variable : local.overwrite_global != null ? local.overwrite_global : null

    mounts_computed = local.mounts_variable != null ? local.mounts_variable : local.mounts_global != null ? local.mounts_global : null
    ipv4_computed = {
        address = local.ipv4_variable.address != null ? local.ipv4_variable.address : local.ipv4_global.address != null ? local.ipv4_global.address : null
        gateway = local.ipv4_variable.gateway != null ? local.ipv4_variable.gateway : local.ipv4_global.gateway != null ? local.ipv4_global.gateway : null
    }

    # ###########################
    users_computed = local.users_variable != null ? local.users_variable : local.users_global != null ? local.users_global : null
    gitconfig_computed = {
        username = local.gitconfig_variable.username != null ? local.gitconfig_variable.username : local.gitconfig_global.username != null ? local.gitconfig_global.username : null
        email = local.gitconfig_variable.email != null ? local.gitconfig_variable.email : local.gitconfig_global.email != null ? local.gitconfig_global.email : null
        github_pat = local.gitconfig_variable.github_pat != null ? local.gitconfig_variable.github_pat : local.gitconfig_global.github_pat != null ? local.gitconfig_global.github_pat : null
    }

}


locals { # Logic
    type = can(regex("talos", var.name)) ? "talos" : "cloud" 
    template = { 
        
        cloud = templatefile(local.source.cloud, {
            hostname = local.name
            gitconfig = local.gitconfig_computed
            mounts = [for m in local.mounts_computed : jsonencode(m)]
            base64 = {
                gitconfig = base64encode(templatefile(local.source.gitconfig, {
                    gitconfig = local.gitconfig_computed
                }))
            }
            users = [
                for user in local.users_computed : trimspace(jsonencode({
                    for k, v in user : k => v if v != null
                }))
            ]
        })
        talos = templatefile(local.source.talos, { 
            hostname = local.name
        }) 
        network = templatefile(local.source.network, {
            ipv4 = local.ipv4_computed
        }) 
    } 
}
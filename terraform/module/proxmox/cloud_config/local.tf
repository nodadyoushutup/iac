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
    auth_variable = {
        username = try(var.auth.username, null)
        password = try(var.auth.password, null)
    }
    github_variable = {
        username = try(var.github.username, null)
        email = try(var.github.email, null)
    }
    mounts_variable = try(var.mounts, null)
    ipv4_variable = {
        address = try(var.ipv4.address, null)
        gateway = try(var.ipv4.gateway, null)
    }
}

locals { # Global
    datastore_id_global = try(var.config.proxmox.global.machine.cloud_config.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.machine.cloud_config.node_name, null)
    overwrite_global = try(var.config.proxmox.global.machine.cloud_config.overwrite, null)
    auth_global = {
        username = try(var.config.proxmox.global.machine.cloud_config.auth.username, null)
        password = try(var.config.proxmox.global.machine.cloud_config.auth.password, null)
    }
    github_global = {
        username = try(var.config.proxmox.global.machine.cloud_config.github.username, null)
        email = try(var.config.proxmox.global.machine.cloud_config.github.email, null)
    }
    mounts_global = try(var.config.proxmox.global.machine.cloud_config.mounts, null)
    ipv4_global = {
        address = try(var.config.proxmox.global.machine.cloud_config.ipv4.address, null)
        gateway = try(var.config.proxmox.global.machine.cloud_config.ipv4.gateway, null)
    }
}

locals { # Computed
    datastore_id_computed = local.datastore_id_variable != null ? local.datastore_id_variable : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_variable != null ? local.node_name_variable : local.node_name_global != null ? local.node_name_global : null
    overwrite_computed = local.overwrite_variable != null ? local.overwrite_variable : local.overwrite_global != null ? local.overwrite_global : null
    auth_computed = {
        username = local.auth_variable.username != null ? local.auth_variable.username : local.auth_global.username != null ? local.auth_global.username : null
        password = local.auth_variable.password != null ? local.auth_variable.password : local.auth_global.password != null ? local.auth_global.password : null
    }
    github_computed = {
        username = local.github_variable.username != null ? local.github_variable.username : local.github_global.username != null ? local.github_global.username : null
        email = local.github_variable.email != null ? local.github_variable.email : local.github_global.email != null ? local.github_global.email : null
    }
    mounts_computed = local.mounts_variable != null ? local.mounts_variable : local.mounts_global != null ? local.mounts_global : null
    ipv4_computed = {
        address = local.ipv4_variable.address != null ? local.ipv4_variable.address : local.ipv4_global.address != null ? local.ipv4_global.address : null
        gateway = local.ipv4_variable.gateway != null ? local.ipv4_variable.gateway : local.ipv4_global.gateway != null ? local.ipv4_global.gateway : null
    }
}


locals { # Logic
    type = can(regex("talos", var.name)) ? "talos" : "cloud" 
    template = { 
        
        cloud = templatefile(local.source.cloud, {
            hostname = local.name
            username = local.auth_computed.username
            github = local.github_computed
            mounts = local.mounts_computed
            password = data.external.hash_password.result.data != "" ? data.external.hash_password.result.data : null
            base64 = {
                gitconfig = base64encode(templatefile(local.source.gitconfig, {
                    github = local.github_computed
                }))
            }
        })
        talos = templatefile(local.source.talos, { 
            hostname = local.name
        }) 
        network = templatefile(local.source.network, {
            ipv4 = local.ipv4_computed
        }) 
    } 
}
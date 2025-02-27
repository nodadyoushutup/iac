locals { # Required
    name = var.name
}

locals { # Constant
    source = { 
        cloud = "${path.module}/template/cloud_config.yaml.tpl"
        talos = "${path.module}/template/talos_config.yaml.tpl"
        network = "${path.module}/template/network_config.yaml.tpl"
    }
}
locals { # Variable
    datastore_id_variable = try(var.datastore_id, null)
    node_name_variable = try(var.node_name, null)
    username_variable = try(var.username, null)
    address_variable = try(var.address, null)
    overwrite_variable = try(var.overwrite, null)
    github_variable = try(var.github, null)
    gateway_variable = try(var.gateway, null)
    password_variable = try(var.password, null)
}

locals { # Global
    datastore_id_global = try(var.config.proxmox.global.cloud_config.datastore_id, null)
    node_name_global = try(var.config.proxmox.global.cloud_config.node_name, null)
    username_global = try(var.config.proxmox.global.cloud_config.username, null)
    address_global = try(var.config.proxmox.global.cloud_config.address, null)
    overwrite_global = try(var.config.proxmox.global.cloud_config.overwrite, null)
    github_global = try(var.config.proxmox.global.cloud_config.github, null)
    gateway_global = try(var.config.proxmox.global.cloud_config.gateway, null)
    password_global = try(var.config.proxmox.global.cloud_config.password, null)
}

locals { # Computed
    datastore_id_computed = local.datastore_id_variable != null ? local.datastore_id_variable : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_variable != null ? local.node_name_variable : local.node_name_global != null ? local.node_name_global : null
    username_computed = local.username_variable != null ? local.username_variable : local.username_global != null ? local.username_global : null
    address_computed = local.address_variable != null ? local.address_variable : local.address_global != null ? local.address_global : null
    overwrite_computed = local.overwrite_variable != null ? local.overwrite_variable : local.overwrite_global != null ? local.overwrite_global : null
    github_computed = local.github_variable != null ? local.github_variable : local.github_global != null ? local.github_global : null
    gateway_computed = local.gateway_variable != null ? local.gateway_variable : local.gateway_global != null ? local.gateway_global : null
    password_computed = local.password_variable != null ? local.password_variable : local.password_global != null ? local.password_global : null
}


locals { # Logic
    type = can(regex("talos", var.name)) ? "talos" : "cloud" 
    template = { 
        cloud = templatefile(local.source.cloud, {
            hostname = local.name
            username = local.username_computed
            github = local.github_computed
            password = local.password_computed
        }) 
        talos = templatefile(local.source.talos, { 
            hostname = var.name 
        }) 
        network = templatefile(local.source.network, {
            address = local.address_computed
            gateway = local.gateway_computed
        }) 
    } 
}

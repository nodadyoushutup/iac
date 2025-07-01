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
    overwrite_variable = try(var.overwrite, null)
    auth_variable = {
        username = try(var.auth.username, null)
        password = try(var.auth.password, null)
        github = try(var.auth.github, null)
    }
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
        github = try(var.config.proxmox.global.machine.cloud_config.auth.github, null)
    }
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
        github = local.auth_variable.github != null ? local.auth_variable.github : local.auth_global.github != null ? local.auth_global.github : null
    }
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
            github = local.auth_computed.github
            password = data.external.hash_password.result.data != "" ? data.external.hash_password.result.data : null
            base64 = {
                netplan = base64encode(file("${path.module}/script/netplan.sh"))
                ssh_import = base64encode(file("${path.module}/script/ssh_import.sh"))
                apt = base64encode(file("${path.module}/script/apt.sh"))
                docker = base64encode(file("${path.module}/script/docker.sh"))
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
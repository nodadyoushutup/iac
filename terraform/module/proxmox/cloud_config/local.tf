locals { # Required
    name = var.name
}

locals { # Constant
    source = {
        talos    = "${path.module}/template/talos_config.yaml.tpl"
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
    network_variable = try(var.network, null)

    # #############################
    users_variable = try(var.users, null)
    groups_variable = try(var.groups, null)
    bootcmd_variable = try(var.bootcmd, null)
    runcmd_variable = try(var.runcmd, null)
    gitconfig_variable = {
        username = try(var.gitconfig.username, null)
        email = try(var.gitconfig.email, null)
        github_pat = try(var.gitconfig.github_pat, null)
    }
    write_files_variable = try(var.write_files, null)
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
    network_global = try(var.config.proxmox.global.machine.cloud_config.network, null)

    # ############################
    users_global = try(var.config.proxmox.global.machine.cloud_config.users, null)
    groups_global = try(var.config.proxmox.global.machine.cloud_config.groups, null)
    gitconfig_global = {
        username = try(var.config.proxmox.global.machine.cloud_config.gitconfig.username, null)
        email = try(var.config.proxmox.global.machine.cloud_config.gitconfig.email, null)
        github_pat = try(var.config.proxmox.global.machine.cloud_config.gitconfig.github_pat, null)
    }
    write_files_global = try(var.config.proxmox.global.machine.cloud_config.write_files, null)
    bootcmd_global = try(var.config.proxmox.global.machine.cloud_config.bootcmd, null)
    runcmd_global = try(var.config.proxmox.global.machine.cloud_config.runcmd, null)
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
    network_computed = local.network_variable != null ? local.network_variable : local.network_global != null ? local.network_global : null

    # ###########################
    users_computed = local.users_variable != null ? local.users_variable : local.users_global != null ? local.users_global : null
    groups_computed = local.groups_variable != null ? local.groups_variable : local.groups_global != null ? local.groups_global : null
    gitconfig_computed = {
        username = local.gitconfig_variable.username != null ? local.gitconfig_variable.username : local.gitconfig_global.username != null ? local.gitconfig_global.username : null
        email = local.gitconfig_variable.email != null ? local.gitconfig_variable.email : local.gitconfig_global.email != null ? local.gitconfig_global.email : null
        github_pat = local.gitconfig_variable.github_pat != null ? local.gitconfig_variable.github_pat : local.gitconfig_global.github_pat != null ? local.gitconfig_global.github_pat : null
    }
    bootcmd_computed = local.bootcmd_variable != null ? local.bootcmd_variable : local.bootcmd_global != null ? local.bootcmd_global : null
    runcmd_computed = local.runcmd_variable != null ? local.runcmd_variable : local.runcmd_global != null ? local.runcmd_global : null
    write_files_computed = local.write_files_variable != null ? local.write_files_variable : local.write_files_global != null ? local.write_files_global : null
}


locals { # Logic
    type = can(regex("talos", var.name)) ? "talos" : "cloud" 
    base64 = {
        gitconfig = base64encode(templatefile(local.source.gitconfig, {
            gitconfig = local.gitconfig_computed
        }))
    }

    write_files_gitconfig = local.users_computed == null ? [] : [
        for user in local.users_computed : {
            path        = "/home/${user.name}/.gitconfig"
            permissions = "0640"
            encoding    = "b64"
            content     = local.base64.gitconfig
            owner       = "${user.name}:${user.name}"
            defer       = true
        }
    ]

    write_files_extra = local.write_files_computed == null ? [] : [
        for write_file in local.write_files_computed : {
            for k, v in write_file : k => v if v != null
        }
    ]
    bootcmd_extra = local.bootcmd_computed == null ? [] : local.bootcmd_computed
    runcmd_extra  = local.runcmd_computed == null ? [] : local.runcmd_computed
    runcmd_base   = (local.gitconfig_computed.github_pat != null && local.users_computed != null && length(local.users_computed) > 0) ? [
        for user in local.users_computed : "su - ${user.name} -c \"/script/register_github_public_key.sh ${local.gitconfig_computed.github_pat}\""
    ] : []

    groups_data = local.groups_computed == null ? null : [
        for group in local.groups_computed : {"${group}" = []}
    ]

    mounts_object = local.mounts_computed != null ? {
        mounts               = local.mounts_computed
    } : {}

    mount_default_fields_object = local.mounts_computed != null ? {
        mount_default_fields = [null, null, "auto", "defaults,nofail", "0", "2"]
    } : {}

    groups_object = local.groups_data != null ? {
        groups = local.groups_data
    } : {}

    write_files_object = length(local.write_files_gitconfig) + length(local.write_files_extra) > 0 ? {
        write_files = concat(local.write_files_gitconfig, local.write_files_extra)
    } : {}

    runcmd_object = length(local.runcmd_base) + length(local.runcmd_extra) > 0 ? {
        runcmd = concat(local.runcmd_base, local.runcmd_extra)
    } : {}

    bootcmd_object = {
        bootcmd = concat(["netplan apply"], local.bootcmd_extra)
    }

    hostname_object = {
        hostname = local.name
    }

    users_object = {
        users = concat(
            ["default"],
            local.users_computed == null ? [] : [
                for user in local.users_computed : {
                    for k, v in user : k => v if v != null
                }
            ]
        )
    }

    ipv4_address_object = local.ipv4_computed.address != null && local.ipv4_computed.address != "dhcp" ? {
        dhcp4    = "no"
        addresses = ["${local.ipv4_computed.address}/24"]
    } : {
        dhcp4 = "yes"
        addresses = []
    }

    ipv4_gateway_object = (local.ipv4_computed.address != null && local.ipv4_computed.address != "dhcp" && local.ipv4_computed.gateway != null) ? {
        gateway4 = local.ipv4_computed.gateway
    } : {}
}

locals { # Template
    cloud_config_data = merge(
        local.bootcmd_object,
        local.hostname_object,
        local.users_object,
        local.mounts_object,
        local.mount_default_fields_object,
        local.groups_object,
        local.write_files_object,
        local.runcmd_object,
    )

    cloud_config_yaml = "#cloud-config\n${yamlencode(local.cloud_config_data)}"

    network_config_yaml = "#cloud-config\n${yamlencode({ network = local.network_computed })}"

    template = {
        cloud   = local.cloud_config_yaml
        talos   = templatefile(local.source.talos, {
            hostname = local.name
        })
        network = local.network_config_yaml
    }
}

locals { # Required
    name = var.name
}

locals { # Constant
    url = {
        cloud = "https://cir.nodadyoushutup.com/public/jammy-cloud-image-amd64-0.1.94.img"
        # cloud = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
        talos = "https://github.com/nodadyoushutup/talos-image/releases/download/0.1.0/talos-image-amd64-0.1.0.img"
    }
}
locals { # Variable
    datastore_id_variable = try(var.datastore_id, null)
    file_name_variable = try(var.file_name, null)
    node_name_variable = try(var.node_name, null)
    url_variable = try(var.url, null)
    overwrite_variable = try(var.overwrite, null)
    overwrite_unmanaged_variable = try(var.overwrite_unmanaged, null)
}

locals { # Global
    datastore_id_global = try(var.config.proxmox.global.machine.image.datastore_id, null)
    file_name_global = try(var.config.proxmox.global.machine.image.file_name, null)
    node_name_global = try(var.config.proxmox.global.machine.image.node_name, null)
    url_global = try(var.config.proxmox.global.machine.image.url, null)
    overwrite_global = try(var.config.proxmox.global.machine.image.overwrite, null)
    overwrite_unmanaged_global = try(var.config.proxmox.global.machine.image.overwrite_unmanaged, null)
}

locals { # Computed
    datastore_id_computed = local.datastore_id_variable != null ? local.datastore_id_variable : local.datastore_id_global != null ? local.datastore_id_global : null
    node_name_computed = local.node_name_variable != null ? local.node_name_variable : local.node_name_global != null ? local.node_name_global : null
    url_computed = local.url_variable != null ? local.url_variable : local.url_global != null ? local.url_global : local.url_default
    overwrite_computed = local.overwrite_variable != null ? local.overwrite_variable : local.overwrite_global != null ? local.overwrite_global : null
    overwrite_unmanaged_computed = local.overwrite_unmanaged_variable != null ? local.overwrite_unmanaged_variable : local.overwrite_unmanaged_global != null ? local.overwrite_unmanaged_global : null
}


locals { # Logic
    file_name = local.file_name_variable != null ? "${local.name}-${local.file_name_variable}" : local.file_name_global != null ? "${local.name}-${local.file_name_global}" : "${local.name}-image.img"
    url_default = can(regex("talos", local.name)) ? local.url.talos : local.url.cloud
}

resource "proxmox_virtual_environment_file" "cloud" {
    content_type = "snippets"
    datastore_id = "config"
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.type == "talos" ? local.template.talos : local.template.cloud
        file_name = "${local.name}-cloud-config.yaml"
    }
}

resource "proxmox_virtual_environment_file" "network" {
    content_type = "snippets"
    datastore_id = "config"
    node_name = local.node_name_computed
    overwrite = local.overwrite_computed

    source_raw {
        data = local.template.network
        file_name = "${local.name}-network-config.yaml"
    }
}

data "external" "hash_password" {
    program = ["python3", "hash_password.py"]

    query = {
        password = local.password_computed
    }
}

output "zzz" {
    value = data.external.hash_password.result.data
}
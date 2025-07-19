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

    template = {
        cloud   = "#cloud-config\n${yamlencode(local.cloud_config_data)}"
        network = "#cloud-config\n${yamlencode({network=local.network_computed })}"
        talos   = templatefile(local.source.talos, {
            hostname = local.name
        })
    }
}

locals { # Template
    template_data = merge(
        # local.bootcmd_object,
        # local.hostname_object,
        # local.users_object,
        # local.mounts_object,
        # local.mount_default_fields_object,
        # local.groups_object,
        # local.write_files_object,
        # local.runcmd_object,
    )

    template = "#cloud-config\n${yamlencode(local.template_data)}"
}

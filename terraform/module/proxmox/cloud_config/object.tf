locals { # Objects
    mounts_object = local.mounts_computed != null ? {
        mounts               = local.mounts_computed
    } : {}

    mount_default_fields_object = local.mounts_computed != null ? {
        mount_default_fields = [null, null, "auto", "defaults,nofail", "0", "2"]
    } : {}

    groups_object = local.groups_computed != null ? {
        groups = local.groups_computed
    } : {}

    write_files_object = length(local.write_files_base) + length(local.write_files_extra) > 0 ? {
        write_files = concat(local.write_files_base, local.write_files_extra)
    } : {}

    runcmd_object = length(local.runcmd_base) + length(local.runcmd_computed) > 0 ? {
        runcmd = concat(local.runcmd_base, local.runcmd_computed)
    } : {}

    bootcmd_object = {
        bootcmd = concat(local.bootcmd_base, local.bootcmd_computed)
    }

    hostname_object = {
        hostname = local.name
    }

    users_object = {
        users = concat(
            ["default"],
            local.users_computed != null ? [
                for user in local.users_computed : {
                    for k, v in user : k => v if v != null
                }
            ] : []
        )
    }
}
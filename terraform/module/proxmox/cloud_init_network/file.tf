locals {
  base64 = {
        gitconfig = base64encode(templatefile(local.source.gitconfig, {
            gitconfig = local.gitconfig_computed
        }))
    }
    write_files_base = local.users_computed != null ? [
        {
            path = "/etc/skel/.gitconfig"
            permissions = "0640"
            encoding = "b64"
            content = local.base64.gitconfig
            defer = false
        }
    ] : []
    write_files_extra = local.write_files_computed != null ? [
        for write_file in local.write_files_computed : {
            for k, v in write_file : k => v if v != null
        }
    ] : []
}
locals {
    cloud_config ={
        cloud = templatefile(
            "${path.module}/template/cloud_config.yaml.tpl",
            {
                hostname = var.cloud_config.hostname != null ? var.cloud_config.hostname : var.name
                username = var.cloud_config.auth.username
                ssh_public_key = var.cloud_config.auth.ssh_public_key != [] ? var.cloud_config.auth.ssh_public_key : []
                ssh_import = var.cloud_config.auth.github != null ? "su - ${var.cloud_config.auth.username} -c 'ssh-import-id gh:${var.cloud_config.auth.github}'" : "echo 'No SSH import'"
                runcmd = var.cloud_config.runcmd
            }
        )
        talos = templatefile(
            "${path.module}/template/talos_cloud_config.yaml.tpl",
            {
                hostname = var.cloud_config.hostname != null ? var.cloud_config.hostname : var.name
            }
        )
    }
}
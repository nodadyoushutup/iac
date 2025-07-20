module "cloud_init_user" {
  source = "../cloud_init_user"

  config       = var.config
  name         = var.name
  datastore_id = var.datastore_id
  node_name    = var.node_name
  overwrite    = var.overwrite

  gitconfig   = var.gitconfig
  mounts      = var.mounts
  users       = var.users
  groups      = var.groups
  write_files = var.write_files
  bootcmd     = var.bootcmd
  runcmd      = var.runcmd
}

module "cloud_init_network" {
  source = "../cloud_init_network"

  config       = var.config
  name         = var.name
  datastore_id = var.datastore_id
  node_name    = var.node_name
  overwrite    = var.overwrite

  ethernets = try(var.network.ethernets, null)
  # Additional advanced settings (bonds, bridges, vlans) can be added to var.network
}

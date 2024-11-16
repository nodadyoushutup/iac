resource "talos_machine_secrets" "this" {
    talos_version = "1.8.3"
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.control_plane[0].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.control_plane[0].port}"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = local.config.talos.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [
    for control_plane in local.config.talos.control_plane :
    "${control_plane.ip_address}:${control_plane.port}"
  ]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = { for idx, control_plane in local.config.talos.control_plane : idx => control_plane }
  node                        = "${each.value.ip_address}:${each.value.port}"
}

# data "talos_machine_configuration" "talos_cp_0" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.control_plane[0].port}"
#   machine_type     = "controlplane"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_cp_1" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.control_plane[1].port}"
#   machine_type     = "controlplane"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_cp_2" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.control_plane[2].port}"
#   machine_type     = "controlplane"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_wk_0" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.worker[0].port}"
#   machine_type     = "worker"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_wk_1" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.worker[1].port}"
#   machine_type     = "worker"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_wk_2" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.worker[2].port}"
#   machine_type     = "worker"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_machine_configuration" "talos_wk_3" {
#   cluster_name     = local.config.talos.cluster_name
#   cluster_endpoint = "https://${local.config.talos.ip_address}:${local.config.talos.worker[2].port}"
#   machine_type     = "worker"
#   machine_secrets  = talos_machine_secrets.this.machine_secrets
# }

# data "talos_client_configuration" "this" {
#   cluster_name         = var.cluster_name
#   client_configuration = talos_machine_secrets.this.client_configuration
#   endpoints            = [for k, v in var.node_data.controlplanes : k]
# }

# resource "talos_machine_configuration_apply" "talos_cp_0" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_cp_0.machine_configuration
#   for_each                    = var.node_data.controlplanes # local.config.talos.control_plane
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     }),
#     file("${path.module}/file/cp-scheduling.yaml"),
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_cp_1" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_cp_1.machine_configuration
#   for_each                    = var.node_data.controlplanes
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     }),
#     file("${path.module}/file/cp-scheduling.yaml"),
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_cp_2" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_cp_2.machine_configuration
#   for_each                    = var.node_data.controlplanes
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     }),
#     file("${path.module}/file/cp-scheduling.yaml"),
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_wk_0" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_wk_0.machine_configuration
#   for_each                    = var.node_data.workers
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     })
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_wk_1" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_wk_1.machine_configuration
#   for_each                    = var.node_data.workers
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     })
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_wk_2" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_wk_2.machine_configuration
#   for_each                    = var.node_data.workers
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     })
#   ]
# }

# resource "talos_machine_configuration_apply" "talos_wk_3" {
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.talos_wk_3.machine_configuration
#   for_each                    = var.node_data.workers
#   node                        = each.key
#   config_patches = [
#     templatefile("${path.module}/template/install-disk-and-hostname.yaml.tmpl", {
#       hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
#       install_disk = each.value.install_disk
#     })
#   ]
# }

# resource "talos_machine_bootstrap" "this" {
#   depends_on = [talos_machine_configuration_apply.talos_cp_0]

#   client_configuration = talos_machine_secrets.this.client_configuration
#   node                 = [for k, v in var.node_data.controlplanes : k][0]
# }

# resource "talos_cluster_kubeconfig" "this" {
#   depends_on           = [talos_machine_bootstrap.this]
#   client_configuration = talos_machine_secrets.this.client_configuration
#   node                 = [for k, v in var.node_data.controlplanes : k][0]
# }
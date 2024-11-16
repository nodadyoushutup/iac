resource "talos_machine_secrets" "this" {
    talos_version = "1.8.3"
}

data "talos_machine_configuration" "talos_cp_0" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_cp_1" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.control_plane[1].ip_address}:${local.config.talos.control_plane[1].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_cp_2" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.control_plane[2].ip_address}:${local.config.talos.control_plane[2].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_wk_0" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.worker[0].ip_address}:${local.config.talos.worker[0].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_wk_1" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.worker[1].ip_address}:${local.config.talos.worker[1].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_wk_2" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.worker[2].ip_address}:${local.config.talos.worker[2].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "talos_wk_3" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "https://${local.config.talos.worker[2].ip_address}:${local.config.talos.worker[2].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.node_data.controlplanes : k]
}
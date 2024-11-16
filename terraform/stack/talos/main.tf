resource "talos_machine_secrets" "this" {
    talos_version = "1.8.3"
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = local.config.talos.cluster_name
  cluster_endpoint = "${local.config.talos.control_plane[0].protocol}://${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}
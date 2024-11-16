resource "talos_machine_secrets" "this" {
    talos_version = "1.8.3"
}

data "talos_machine_configuration" "controlplane" {
    depends_on = [ talos_machine_secrets.this ]
    cluster_name     = local.config.talos.cluster_name
    cluster_endpoint = "https://${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
    machine_type     = "controlplane"
    machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
    depends_on = [ talos_machine_secrets.this ]
    cluster_name     = local.config.talos.cluster_name
    cluster_endpoint = "https://${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
    machine_type     = "worker"
    machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
    depends_on = [ 
        talos_machine_secrets.this, 
        data.talos_machine_configuration.controlplane, 
        data.talos_machine_configuration.worker 
    ]
    cluster_name         = local.config.talos.cluster_name
    client_configuration = talos_machine_secrets.this.client_configuration
    endpoints            = [
        for control_plane in local.config.talos.control_plane :
        "${control_plane.ip_address}:${control_plane.port}"
    ]
}

resource "talos_machine_configuration_apply" "controlplane" {
    depends_on = [ 
        talos_machine_secrets.this,
        data.talos_machine_configuration.controlplane 
    ]
    client_configuration        = talos_machine_secrets.this.client_configuration
    machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
    for_each                    = { for idx, control_plane in local.config.talos.control_plane : idx => control_plane }
    node                        = "${each.value.ip_address}:${each.value.port}"
}

resource "talos_machine_configuration_apply" "worker" {
    depends_on = [ 
        talos_machine_secrets.this,
        data.talos_machine_configuration.worker 
    ]
    client_configuration        = talos_machine_secrets.this.client_configuration
    machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
    for_each                    = { for idx, worker in local.config.talos.worker : idx => worker }
    node                        = "${each.value.ip_address}:${each.value.port}"
}

resource "talos_machine_bootstrap" "this" {
    depends_on = [ 
        talos_machine_secrets.this.client_configuration,
        talos_machine_configuration_apply.controlplane 
    ]
    client_configuration = talos_machine_secrets.this.client_configuration
    node                 = "${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
}

# resource "talos_cluster_kubeconfig" "this" {
#     depends_on = [ 
#         talos_machine_secrets.this.client_configuration,
#         talos_machine_bootstrap.this
#     ]
#     client_configuration = talos_machine_secrets.this.client_configuration
#     node                 = "${local.config.talos.control_plane[0].ip_address}:${local.config.talos.control_plane[0].port}"
# }
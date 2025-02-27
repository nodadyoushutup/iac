resource "talos_machine_secrets" "talos" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name = local.config.machine.talos.name
  cluster_endpoint = local.cluster_endpoint
  machine_type = "controlplane"
  machine_secrets = talos_machine_secrets.talos.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name = local.config.machine.talos.name
  cluster_endpoint = local.cluster_endpoint
  machine_type = "worker"
  machine_secrets = talos_machine_secrets.talos.machine_secrets
}

data "talos_client_configuration" "talos" {
  cluster_name = local.config.machine.talos.name
  client_configuration = talos_machine_secrets.talos.client_configuration
  endpoints = [for k, v in local.node_data.controlplane : k]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each = local.node_data.controlplane
  node = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-cp-%s", local.config.machine.talos.name, index(keys(local.node_data.controlplane), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    }),
    file("${path.module}/files/cp-scheduling.yaml"),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each = local.node_data.worker
  node = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-worker-%s", local.config.machine.talos.name, index(keys(local.node_data.worker), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_bootstrap" "talos" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.talos.client_configuration
  node = [for k, v in local.node_data.controlplane : k][0]
}

resource "talos_cluster_kubeconfig" "talos" {
  depends_on = [talos_machine_bootstrap.talos]
  client_configuration = talos_machine_secrets.talos.client_configuration
  node = [for k, v in local.node_data.controlplane : k][0]
}

resource "null_resource" "exec_development" {
  depends_on = [talos_cluster_kubeconfig.talos]
  triggers = {
    always_run = timestamp()
  }

  connection {
    type = local.exec.connection.development.type
    user = local.exec.connection.development.user
    private_key = local.exec.connection.development.private_key
    host = local.exec.connection.development.host
    port = local.exec.connection.development.port
  }

  provisioner "remote-exec" {
    inline = concat(
      local.exec.inline.kubeconfig,
    )
  }
}
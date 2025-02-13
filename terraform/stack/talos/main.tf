locals {
    exec = {
        connection = {
            development = {
                type = "ssh"
                user = var.VIRTUAL_MACHINE_GLOBAL_USERNAME
                private_key = file(var.SSH_PRIVATE_KEY)
                host = var.VIRTUAL_MACHINE_DEVELOPMENT_IP_ADDRESS
                port = 22
            }
        }
        inline = {
            kubeconfig = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "mkdir -p /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/",
                "cp -p /tmp/config /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "chown ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}:${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "rm -rf /tmp/config",
            ]
            talosconfig = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "mkdir -p /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/",
                "cp -p /tmp/config /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "chown ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}:${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "rm -rf /tmp/config",
            ]
        }   
    }
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type = string
  default = "talos"
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type = string
  default = "https://192.168.1.200:50000"
}

variable "node_data" {
    description = "A map of node data"
    type = object({
        controlplanes = map(object({
            install_disk = string
            hostname = optional(string)
        }))
        workers = map(object({
            install_disk = string
            hostname = optional(string)
        }))
    })
    default = {
        controlplanes = {
            "192.168.1.200" = {
                install_disk = "/dev/sda"
                hostname = "talos-cp-1"
            },
            # "192.168.1.201" = {
            #     install_disk = "/dev/sda"
            #     hostname = "talos-cp-2"
            # },
            # "192.168.1.202" = {
            #     install_disk = "/dev/sda"
            #     hostname = "talos-cp-3"
            # }
        }
        workers = {
            "192.168.1.203" = {
                install_disk = "/dev/sda"
                hostname = "talos-wk-1"
            },
        }
    }
}

resource "talos_machine_secrets" "talos" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.talos.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.talos.machine_secrets
}

data "talos_client_configuration" "talos" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.talos.client_configuration
  endpoints            = [for k, v in var.node_data.controlplanes : k]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = var.node_data.controlplanes
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    }),
    file("${path.module}/files/cp-scheduling.yaml"),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = var.node_data.workers
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_bootstrap" "talos" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.talos.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
}

resource "talos_cluster_kubeconfig" "talos" {
  depends_on           = [talos_machine_bootstrap.talos]
  client_configuration = talos_machine_secrets.talos.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
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
        local.exec.inline.talosconfig,
    )
  }
}

data "talos_cluster_kubeconfig" "talos" {
    depends_on = [talos_machine_bootstrap.talos]
    client_configuration = talos_machine_secrets.talos.client_configuration
    node = "192.168.1.200"
}

output "kubeconfig" {
    value = talos_cluster_kubeconfig.talos.kubernetes_client_configuration
    sensitive = true
}
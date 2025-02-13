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
        }   
    }

  cp_ips = {
    "talos-cp-1" = "192.168.1.200"
    "talos-cp-2" = "192.168.1.201"
    "talos-cp-3" = "192.168.1.202"
  }

  worker_ips = {
    "talos-wk-1" = "192.168.1.203"
  }

  node_data = {
    controlplanes = {
      for vm in data.proxmox_virtual_environment_vms.talos_controlplane.vms :
      lookup(local.cp_ips, vm.name) => {
        install_disk = "/dev/sda"
        hostname = vm.name
      }
    }
    workers = {
      for vm in data.proxmox_virtual_environment_vms.talos_worker.vms :
      lookup(local.worker_ips, vm.name) => {
        install_disk = "/dev/sda"
        hostname = vm.name
      }
    }
  }
}

locals {
  # Define a mapping of control plane hostnames to IPs.
  
}


variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type = string
  default = "talos"
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type = string
  default = "https://192.168.1.200:6443"
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
  endpoints            = [for k, v in local.node_data.controlplanes : k]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = local.node_data.controlplanes
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-cp-%s", var.cluster_name, index(keys(local.node_data.controlplanes), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    }),
    file("${path.module}/files/cp-scheduling.yaml"),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = local.node_data.workers
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = each.value.hostname == null ? format("%s-worker-%s", var.cluster_name, index(keys(local.node_data.workers), each.key)) : each.value.hostname
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_bootstrap" "talos" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.talos.client_configuration
  node                 = [for k, v in local.node_data.controlplanes : k][0]
}

resource "talos_cluster_kubeconfig" "talos" {
  depends_on           = [talos_machine_bootstrap.talos]
  client_configuration = talos_machine_secrets.talos.client_configuration
  node                 = [for k, v in local.node_data.controlplanes : k][0]
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

data "talos_cluster_kubeconfig" "talos" {
    depends_on = [talos_machine_bootstrap.talos]
    client_configuration = talos_machine_secrets.talos.client_configuration
    node = "192.168.1.200"
}

output "kubeconfig" {
    value = talos_cluster_kubeconfig.talos.kubernetes_client_configuration.ca_certificate
}
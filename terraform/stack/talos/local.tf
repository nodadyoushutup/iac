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
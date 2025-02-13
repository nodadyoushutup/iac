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

    talos = {
        controlplane = [
            {
                ip_address = "192.168.1.200"
                mac_address = "00:11:22:33:44:55"
                vm_id = "1200"
            },
            {
                ip_address = "192.168.1.201"
                mac_address = "00:11:22:33:44:66"
                vm_id = "1201"
            },
            {
                ip_address = "192.168.1.202"
                mac_address = "00:11:22:33:44:77"
                vm_id = "1202"
            },
        ]

        worker = [
            {
                ip_address = "192.168.1.203"
                mac_address = "00:11:22:33:44:88"
                vm_id = "1203"
            }
        ]
    }
    

    node_data = {
        controlplanes = {
            for idx, cp in local.talos.controlplane : cp.ip_address => {
                ip_address = cp.ip_address
                hostname = format("talos-cp-%d", idx + 1)
                install_disk = "/dev/sda"
            }
        }
        workers = {
            for idx, wk in local.talos.worker : wk.ip_address => {
                ip_address  = wk.ip_address
                hostname = format("talos-wk-%d", idx + 1)
                install_disk = "/dev/sda"
            }
        }
    }
}
locals {
    exec = {
        connection = {
            development = {
                type = "ssh"
                user = var.machine.global.user
                private_key = file(var.SSH_PRIVATE_KEY)
                host = var.machine.required.development.ipv4.address
                port = 22
            }
        }
        inline = {
            kubeconfig = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "mkdir -p /home/${var.machine.global.user}/.kube/",
                "cp -p /tmp/config /home/${var.machine.global.user}/.kube/config",
                "chown ${var.machine.global.user}:${var.machine.global.user} /home/${var.machine.global.user}/.kube/config",
                "rm -rf /tmp/config",
            ]
        }   
    }

    node_data = {
        controlplane = {
            for idx, machine in var.machine.talos.controlplane : 
                machine.ipv4.address => {
                hostname = format("talos-cp-%d", idx)
                install_disk = "/dev/sda"
            }
        }
        worker = {
            for idx, machine in var.machine.talos.worker : 
                machine.ipv4.address => {
                hostname = format("talos-wk-%d", idx)
                install_disk = "/dev/sda"
            }
        }
    }

    cluster_endpoint = "https://${var.machine.talos.controlplane[0].ipv4.address}:6443"
}
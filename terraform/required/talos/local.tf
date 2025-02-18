locals {
    exec = {
        connection = {
            development = {
                type = "ssh"
                user = local.machine.global.username
                private_key = file(var.SSH_PRIVATE_KEY)
                host = local.machine.required.development.ipv4.address
                port = 22
            }
        }
        inline = {
            kubeconfig = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "mkdir -p /home/${local.machine.global.username}/.kube/",
                "cp -p /tmp/config /home/${local.machine.global.username}/.kube/config",
                "chown ${local.machine.global.username}:${local.machine.global.username} /home/${local.machine.global.username}/.kube/config",
                "rm -rf /tmp/config",
            ]
        }   
    }

    node_data = {
        controlplane = {
            for idx, machine in local.machine.talos.controlplane : 
                machine.ipv4.address => {
                hostname = format("talos-cp-%d", idx)
                install_disk = "/dev/sda"
            }
        }
        worker = {
            for idx, machine in local.machine.talos.worker : 
                machine.ipv4.address => {
                hostname = format("talos-wk-%d", idx)
                install_disk = "/dev/sda"
            }
        }
    }

    cluster_endpoint = "https://${local.machine.talos.controlplane[0].ipv4.address}:6443"
}
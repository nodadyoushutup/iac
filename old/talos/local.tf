locals {
    exec = {
        connection = {
            development = {
                type = "ssh"
                user = local.config.machine.global.username
                private_key = file(var.SSH_PRIVATE_KEY)
                host = local.config.machine.required.development.ipv4.address
                port = 22
            }
        }
        inline = {
            kubeconfig = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "mkdir -p /home/${local.config.machine.global.username}/.kube/",
                "cp -p /tmp/config /home/${local.config.machine.global.username}/.kube/config",
                "chown ${local.config.machine.global.username}:${local.config.machine.global.username} /home/${local.config.machine.global.username}/.kube/config",
                "rm -rf /tmp/config",
            ]
        }   
    }

    node_data = {
        controlplane = {
            for idx, machine in local.config.machine.talos.controlplane : 
                machine.ipv4.address => {
                hostname = format("talos-cp-%d", idx)
                install_disk = "/dev/sda"
            }
        }
        worker = {
            for idx, machine in local.config.machine.talos.worker : 
                machine.ipv4.address => {
                hostname = format("talos-wk-%d", idx)
                install_disk = "/dev/sda"
            }
        }
    }

    cluster_endpoint = "https://${local.config.machine.talos.controlplane[0].ipv4.address}:6443"
}
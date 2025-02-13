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
            talos = [
                "cat <<EOF > /tmp/config",
                "${talos_cluster_kubeconfig.talos.kubeconfig_raw}",
                "EOF",
                "cp -p /tmp/config /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "chown ${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}:${var.VIRTUAL_MACHINE_GLOBAL_USERNAME} /home/${var.VIRTUAL_MACHINE_GLOBAL_USERNAME}/.kube/config",
                "rm -rf /tmp/config",
            ]
        }   
    }
}
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

    TALOS_CONTROLPLANE = [
        "192.168.1.200",
        "192.168.1.201",
        "192.168.1.202",
    ]
    TALOS_WORKER = [
        "192.168.1.203"
    ]

    node_data = {
        controlplanes = {
        for idx, ip in local.TALOS_CONTROLPLANE : 
        ip => {
            install_disk = "/dev/sda"
            hostname     = "talos-cp-${idx + 1}"
        }
        }
        workers = {
        for idx, ip in local.TALOS_WORKER : 
        ip => {
            install_disk = "/dev/sda"
            hostname     = "talos-wk-${idx + 1}"
        }
        }
    }
}
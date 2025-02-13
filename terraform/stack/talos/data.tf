data "proxmox_virtual_environment_vms" "talos_controlplane" {
    tags = ["talos-controlplane"]
}

data "proxmox_virtual_environment_vms" "talos_worker" {
    tags = ["talos-worker"]
}

output "talos_controlplane" {
    value = data.proxmox_virtual_environment_vms.talos_controlplane
}

output "talos_worker" {
    value = data.proxmox_virtual_environment_vms.talos_worker
}
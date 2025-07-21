output "virtual_machine" {
    value = proxmox_virtual_environment_vm.virtual_machine
}

output "debug" {
    value = local.audio_device_computed
}
module "debug" {
    source = "../../module/proxmox/virtual_machine"
    depends_on = [
        proxmox_virtual_environment_download_file.cloud,
        proxmox_virtual_environment_file.cloud_config
    ]
}

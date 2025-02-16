module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"
  depends_on = [
    proxmox_virtual_environment_download_file.cloud,
    proxmox_virtual_environment_file.cloud_config
  ]

  name = "debug"

  initialization = {
    user_account = {
      username = "nodadyoushutup"
    }
  }

  cloud_config = {
    username = {
      github = "nodadyoushutup"
    }
  }
}

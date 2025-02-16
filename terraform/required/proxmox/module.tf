module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"
  depends_on = [
    proxmox_virtual_environment_download_file.cloud,
    proxmox_virtual_environment_file.cloud_config
  ]

  cloud_config = {
    auth = {
      github = "nodadyoushutup"
      username = "nodadyoushutup"
      ssh_public_key = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQy28xL2wHdR2CMcvl+CY9X6uiC2C2ImuEJAcRZXAwjp2GYBhNZQ51dlu9upAo2WNjvJL/XJY8D8RK/LxLilUHikfK+krZyoMLth6u3dEXw9FLMr2Zs8fAcvmh6ZrpveN8k7T5xU0l3Y/isL/5Ud8Bk89rsvMM2zpTVtAiSJ6b2wqF1X4MonhpHiH3AXbmaPIBOMlzZ6/0xohd4DRB4s8ljdlcq4uznN7/M6h1cpIb4J3jpOADgrQ5vR8Qpc/Nsz1o9eF0+BSRYV3guyA5/CNuZZYTkcNWPONfKre/kAnA7PI9Z1U/epFGF0selhiPNpTpuDZu1nfe6RPLWsaVOJpVugapXslXUuSIMuMnnwSbGv7NmSpSy7ViJb3qI/2KoIVgOa8vV87yOJQKWTmehFgZG1tCX75QJoqdaYKkVsOaMqmmDsICgYXhCi53p8uPc8eZD5pbzjVMzLS6bMbdZA3hW+NVecgc/gH1ezO7MyL7LBGJYrIm5yW0/dVKEtu0EXU= nodadyoushutup@ubuntu"
      ]
    }
  }

  initialization = {
    ip_config = {
      ipv4 = {
        address = "192.168.1.190"
        gateway = "192.168.1.1"
      }
    }
  }

  name = "test"
  
  vm_id = 190
}
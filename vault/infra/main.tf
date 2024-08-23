module "vault" {
  source  = "spacelift.io/nodadyoushutup/virtual_machine/proxmox"
  # version = "1.0.0"
  vm_id = 102
  name = "vault"
  description = "HashiCorp Vault"
  tags = ["terraform", "ubuntu", "vault"]
  disk = {
    size = 20
  }
  memory = {
    dedicated = 4096
  }
  cpu = {
    cores = 1
  }
  initialization = {
    ip_config = {
      ipv4 = {
        address = "192.168.1.102/24"
        gateway = "192.168.1.1"
      }
    }
  }
}
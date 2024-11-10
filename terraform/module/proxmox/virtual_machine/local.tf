# modules/proxmox/virtual_machine/local.tf

locals {
  config = try(yamldecode(file("/mnt/workspace/config.yaml")), yamldecode(file("/mnt/workspace/config.yml")))
  virtual_machine = try(yamldecode(file("/mnt/workspace/virtual_machine.yaml")), yamldecode(file("/mnt/workspace/virtual_machine.yml")))
}

# TODO: Migrate contents from virtual_machine.yaml to the main config yaml
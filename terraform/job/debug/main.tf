locals {
  machines = { for k, v in try(local.config.proxmox.machine, []) : k => v }
}

module "virtual_machine" {
  for_each = local.machines
  source   = "../../module/proxmox/virtual_machine"

  config = local.config

  cloud_init       = try(each.value.cloud_init, null)
  agent            = try(each.value.agent, null)
  audio_device     = try(each.value.audio_device, null)
  bios             = try(each.value.bios, null)
  boot_order       = try(each.value.boot_order, null)
  cpu              = try(each.value.cpu, null)
  description      = try(each.value.description, null)
  disk             = try(each.value.disk, null)
  machine          = try(each.value.machine, null)
  memory           = try(each.value.memory, null)
  name             = try(each.value.name, null)
  network_device   = try(each.value.network_device, null)
  node_name        = try(each.value.node_name, null)
  on_boot          = try(each.value.on_boot, null)
  operating_system = try(each.value.operating_system, null)
  started          = try(each.value.started, null)
  startup          = try(each.value.startup, null)
  tags             = try(each.value.tags, null)
  stop_on_destroy  = try(each.value.stop_on_destroy, null)
  vga              = try(each.value.vga, null)
  vm_id            = try(each.value.vm_id, null)
}

output "virtual_machine" {
  value = { for k, m in module.virtual_machine : k => m.debug }
}

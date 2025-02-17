module "cloud_required" {
  source = "../../module/proxmox/virtual_machine"
  for_each = { for machine in var.machine.cloud.required : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}

module "cloud_custom" {
  source = "../../module/proxmox/virtual_machine"
  for_each = { for machine in var.machine.cloud.custom : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}

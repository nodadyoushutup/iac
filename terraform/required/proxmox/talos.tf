module "talos_controlplane" {
  source = "../../module/proxmox/virtual_machine"
  for_each = { for machine in var.machine.talos.controlplane : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}

module "talos_worker" {
  source = "../../module/proxmox/virtual_machine"
  for_each = { for machine in var.machine.talos.worker : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}
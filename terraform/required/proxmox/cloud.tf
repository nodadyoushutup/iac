module "cloud_required" {
  source = "../../module/proxmox/virtual_machine"
  for_each = { for machine in var.machine.cloud.required : machine.name => machine }

  cloud_config = each.value.cloud_config.auth.github != null ? each.value.cloud_config : var.machine.global.cloud_config
  image = try(each.value.image, null) != null ? each.value.image : {}
  initialization = try(each.value.initialization, null) != null ? each.value.initialization : {}
  name = each.value.name
  vm_id = try(each.value.vm_id, null) != null ? each.value.vm_id : null
}

# module "cloud_custom" {
#   source = "../../module/proxmox/virtual_machine"
#   for_each = { for machine in var.machine.cloud.custom : machine.name => machine }

#   cloud_config = each.value.cloud_config.auth.github != null ? each.value.cloud_config : var.machine.global.cloud_config
#   image = try(each.value.image, false) ? each.value.image : {}
#   initialization = try(each.value.initialization, false) ? each.value.initialization : {}
#   name = each.value.name
#   vm_id = try(each.value.vm_id, false) ? each.value.vm_id : null
# }
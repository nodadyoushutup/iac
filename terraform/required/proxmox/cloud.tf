module "cloud_required" {
  source = "../../module/proxmox/virtual_machine"
  for_each = {
    for idx, machine in local.config.machine.cloud.required :
    try(machine.name, null) != null ? machine.name : "default_${idx}" => machine
  }

  cloud_config = each.value.cloud_config.auth.github != null ? each.value.cloud_config : local.config.machine.global.cloud_config
  image = try(each.value.image, null) != null ? each.value.image : {}
  initialization = try(each.value.initialization, null) != null ? each.value.initialization : null
  name = try(each.value.name, null) != null ? each.value.name : null
  vm_id = try(each.value.vm_id, null) != null ? each.value.vm_id : null
}
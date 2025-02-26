# locals {
#   cloud = try(local.config.proxmox.machine.cloud, null) != null ? local.config.proxmox.machine.cloud : {}
# }

# module "cloud" {
#   source = "../../module/proxmox/virtual_machine"
#   for_each = local.cloud

#   config = local.config

#   cloud_config = {
#     hostname = try(each.value.cloud_config.hostname, null)
#     datastore_id = try(each.value.cloud_config.datastore_id, null)
#     file_name = try(each.value.cloud_config.file_name, null)
#     node_name = try(each.value.cloud_config.node_name, null)
#     runcmd = try(each.value.cloud_config.runcmd, null)
#     auth = {
#       github = try(each.value.cloud_config.auth.github, null)
#       username = try(each.value.cloud_config.auth.username, null)
#       ssh_public_key = try(trim(file(each.value.cloud_config.auth.ssh_public_key).content), null)
#     }
#   }

#   image = {
#     datastore_id = try(each.value.image.datastore_id, null)
#     node_name = try(each.value.image.node_name, null)
#     overwrite = try(each.value.image.overwrite, null)
#     overwrite_unmanaged = try(each.value.image.overwrite_unmanaged, null)
#     file_name = try(each.value.image.file_name, null)
#     url = try(each.value.image.url, null)
#   }

#   agent = {
#     enabled = try(each.value.agent.enabled, null)
#     timeout = try(each.value.agent.timeout, null)
#     trim = try(each.value.agent.trim, null)
#     type = try(each.value.agent.type, null)
#   }

#   audio_device = {
#     device = try(each.value.audio_device.device, null)
#     driver = try(each.value.audio_device.driver, null)
#     enabled = try(each.value.audio_device.enabled, null)
#   }

#   bios = try(each.value.bios, null)

#   boot_order = try(each.value.boot_order, null)

#   cpu = {
#     affinity = try(each.value.cpu.affinity, null)
#     cores = try(each.value.cpu.cores, null)
#     flags = try(each.value.cpu.flags, null)
#     hotplugged = try(each.value.cpu.hotplugged, null)
#     limit = try(each.value.cpu.limit, null)
#     numa = try(each.value.cpu.numa, null)
#     sockets = try(each.value.cpu.sockets, null)
#     type = try(each.value.cpu.type, null)
#     units = try(each.value.cpu.units, null)
#   }

#   description = try(each.value.description, null)

#   disk = {
#     aio = try(each.value.disk.aio, null)
#     backup = try(each.value.disk.backup, null)
#     cache = try(each.value.disk.cache, null)
#     datastore_id = try(each.value.disk.datastore_id, null)
#     discard = try(each.value.disk.discard, null)
#     file_format = try(each.value.disk.file_format, null)
#     file_id = try(each.value.disk.file_id, null)
#     interface = try(each.value.disk.interface, null)
#     iothread = try(each.value.disk.iothread, null)
#     replicate = try(each.value.disk.replicate, null)
#     serial = try(each.value.disk.serial, null)
#     size = try(each.value.disk.size, null)
#     ssd = try(each.value.disk.ssd, null)
#   }

#   efi_disk = {
#     datastore_id = try(each.value.efi_disk.datastore_id, null)
#     file_format = try(each.value.efi_disk.file_format, null)
#     type = try(each.value.efi_disk.type, null)
#     pre_enrolled_keys = try(each.value.efi_disk.pre_enrolled_keys, null)
#   }

#   initialization = {
#     datastore_id = try(each.value.initialization.datastore_id, null)
#     user_data_file_id = try(each.value.initialization.user_data_file_id, null)
#     ip_config = {
#       ipv4 = {
#         address = try(each.value.initialization.ip_config.ipv4.address, null)
#         gateway = try(each.value.initialization.ip_config.ipv4.gateway, null)
#       }
#       ipv6 = {
#         address = try(each.value.initialization.ip_config.ipv6.address, null)
#         gateway = try(each.value.initialization.ip_config.ipv6.gateway, null)
#       }
#     }
#   }
                  
#   machine = try(each.value.machine, null)

#   memory = {
#     dedicated = try(each.value.memory.dedicated, null)
#     floating = try(each.value.memory.floating, null)
#     shared = try(each.value.memory.shared, null)
#   }

#   network_device = {
#     bridge = try(each.value.network_device.bridge, null)
#     disconnected = try(each.value.network_device.disconnected, null)
#     enabled = try(each.value.network_device.enabled, null)
#     firewall = try(each.value.network_device.firewall, null)
#     mac_address = try(each.value.network_device.mac_address, null)
#     model = try(each.value.network_device.model, null)
#   }

#   name = try(each.value.name, null) != null ? each.value.name : try(each.key, null) != null ? each.key : null

#   node_name = try(each.value.node_name, null)

#   on_boot = try(each.value.on_boot, null)

#   operating_system = {
#     type = try(each.value.operating_system.type, null)
#   }

#   started = try(each.value.started, null)

#   startup = {
#     order = try(each.value.startup.order, null)
#     up_delay = try(each.value.startup.up_delay, null)
#     down_delay = try(each.value.startup.down_delay, null)
#   }

#   tag = try(each.value.tag, null)

#   stop_on_destroy = try(each.value.stop_on_destroy, null)

#   vga = {
#     memory = try(each.value.vga.memory, null)
#     type = try(each.value.vga.type, null)
#     clipboard = try(each.value.vga.clipboard, null)
#   }

#   vm_id = try(each.value.vm_id, null)
# }

# output "debug" {
#   value = module.cloud.docker.debug
# }
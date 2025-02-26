# locals {
#     global = {
#         agent = {
#             enabled = try(local.config.global.proxmox.machine.agent.enabled, null)
#             timeout = try(local.config.global.proxmox.machine.agent.timeout, null)
#             trim = try(local.config.global.proxmox.machine.agent.trim, null)
#             type = try(local.config.global.proxmox.machine.agent.type, null)
#         }

#         audio_device = {
#             device = try(local.config.global.proxmox.machine.audio_device.device, null)
#             driver = try(local.config.global.proxmox.machine.audio_device.driver, null)
#             enabled = try(local.config.global.proxmox.machine.audio_device.enabled, null)
#         }

#         bios = try(local.config.global.proxmox.machine.bios, null)

#         boot_order = try(local.config.global.proxmox.machine.boot_order, null)

#         cpu = {
#             affinity = try(local.config.global.proxmox.machine.cpu.affinity, null)
#             cores = try(local.config.global.proxmox.machine.cpu.cores, null)
#             flags = try(local.config.global.proxmox.machine.cpu.flags, null)
#             hotplugged = try(local.config.global.proxmox.machine.cpu.hotplugged, null)
#             limit = try(local.config.global.proxmox.machine.cpu.limit, null)
#             numa = try(local.config.global.proxmox.machine.cpu.numa, null)
#             sockets = try(local.config.global.proxmox.machine.cpu.sockets, null)
#             type = try(local.config.global.proxmox.machine.cpu.type, null)
#             units = try(local.config.global.proxmox.machine.cpu.units, null)
#         }

#         description = try(local.config.global.proxmox.machine.description, null)

#         disk = {
#             aio = try(local.config.global.proxmox.machine.disk.aio, null)
#             backup = try(local.config.global.proxmox.machine.disk.backup, null)
#             cache = try(local.config.global.proxmox.machine.disk.cache, null)
#             datastore_id = try(local.config.global.proxmox.machine.disk.datastore_id, null)
#             discard = try(local.config.global.proxmox.machine.disk.discard, null)
#             file_format = try(local.config.global.proxmox.machine.disk.file_format, null)
#             file_id = try(local.config.global.proxmox.machine.disk.file_id, null)
#             interface = try(local.config.global.proxmox.machine.disk.interface, null)
#             iothread = try(local.config.global.proxmox.machine.disk.iothread, null)
#             replicate = try(local.config.global.proxmox.machine.disk.replicate, null)
#             serial = try(local.config.global.proxmox.machine.disk.serial, null)
#             size = try(local.config.global.proxmox.machine.disk.size, null)
#             ssd = try(local.config.global.proxmox.machine.disk.ssd, null)
#         }

#         efi_disk = {
#             datastore_id = try(local.config.global.proxmox.machine.efi_disk.datastore_id, null)
#             file_format = try(local.config.global.proxmox.machine.efi_disk.file_format, null)
#             type = try(local.config.global.proxmox.machine.efi_disk.type, null)
#             pre_enrolled_keys = try(local.config.global.proxmox.machine.efi_disk.pre_enrolled_keys, null)
#         }

#         # initialization

#         machine = try(local.config.global.proxmox.machine.machine, null)

#         memory = {
#             dedicated = try(local.config.global.proxmox.machine.memory.dedicated, null)
#             floating = try(local.config.global.proxmox.machine.memory.floating, null)
#             shared = try(local.config.global.proxmox.machine.memory.shared, null)
#         }

#         network_device = {
#             bridge = try(local.config.global.proxmox.machine.network_device.bridge, null)
#             disconnected = try(local.config.global.proxmox.machine.network_device.disconnected, null)
#             enabled = try(local.config.global.proxmox.machine.network_device.enabled, null)
#             firewall = try(local.config.global.proxmox.machine.network_device.firewall, null)
#             mac_address = try(local.config.global.proxmox.machine.network_device.mac_address, null)
#             model = try(local.config.global.proxmox.machine.network_device.model, null)
#         }

#         name = try(local.config.global.proxmox.machine.name, null)

#         node_name = try(local.config.global.proxmox.machine.node_name, null)

#         on_boot = try(local.config.global.proxmox.machine.on_boot, null)

#         operating_system = {
#             type = try(local.config.global.proxmox.machine.operating_system.type, null)
#         }

#         started = try(local.config.global.proxmox.machine.on_boot, null)

#         startup = {
#             order = try(local.config.global.proxmox.machine.startup.order, null)
#             up_delay = try(local.config.global.proxmox.machine.startup.up_delay, null)
#             down_delay = try(local.config.global.proxmox.machine.startup.down_delay, null)
#         }

#         tags = try(local.config.global.proxmox.machine.tags, null)

#         stop_on_destroy = try(local.config.global.proxmox.machine.stop_on_destroy, null)

#         vga = {
#             memory = try(local.config.global.proxmox.machine.vga.memory, null)
#             type = try(local.config.global.proxmox.machine.vga.type, null)
#             clipboard = try(local.config.global.proxmox.machine.vga.clipboard, null)
#         }

#         vm_id = try(local.config.global.proxmox.machine.vm_id, null)
#     }
# }


# output "debug" {
#   value = local.global
# }
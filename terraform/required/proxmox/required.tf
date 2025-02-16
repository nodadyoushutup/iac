# resource "proxmox_virtual_environment_vm" "required" {
#     for_each = { for idx, machine in var.machine.required : idx => machine }

#     depends_on = [
#         proxmox_virtual_environment_download_file.cloud,
#         proxmox_virtual_environment_file.cloud_config
#     ]
    
#     node_name = var.terraform.proxmox.ssh.node.name

#     agent {
#         enabled = try(each.value.agent.enabled != null, false) ? each.value.agent.enabled : var.machine.global.agent.enabled
#         timeout = try(each.value.agent.timeout != null, false) ? each.value.agent.timeout : var.machine.global.agent.timeout
#         trim = try(each.value.agent.trim != null, false) ? each.value.agent.trim : var.machine.global.agent.trim
#         type = try(each.value.agent.type != null, false) ? each.value.agent.type : var.machine.global.agent.type
#     }

#     audio_device {
#         device = try(each.value.audio_device.device != null, false) ? each.value.audio_device.device : var.machine.global.audio_device.device
#         driver = try(each.value.audio_device.driver != null, false) ? each.value.audio_device.driver : var.machine.global.audio_device.driver
#         enabled = try(each.value.audio_device.enabled != null, false) ? each.value.audio_device.enabled : var.machine.global.audio_device.enabled
#     }

#     # bios = try(each.value.bios != null, false) ? each.value.bios : var.machine.global.bios
#     bios = "seabios"

#     boot_order = try(each.value.boot_order != null, false) ? each.value.boot_order : var.machine.global.boot_order

#     cpu {
#         cores = try(each.value.cpu.cores != null && each.value.cpu.cores > 0, false) ? each.value.cpu.cores : var.machine.global.cpu.cores
#         flags = try(each.value.cpu.flags != null && each.value.cpu.flags > 0, false) ? each.value.cpu.flags : var.machine.global.cpu.flags
#         hotplugged = try(each.value.cpu.hotplugged != null && each.value.cpu.hotplugged > 0, false) ? each.value.cpu.hotplugged : var.machine.global.cpu.hotplugged
#         limit = try(each.value.cpu.limit != null && each.value.cpu.limit > 0, false) ? each.value.cpu.limit : var.machine.global.cpu.limit
#         numa = try(each.value.cpu.numa != null, false) ? each.value.cpu.numa : var.machine.global.cpu.numa
#         sockets = try(each.value.cpu.sockets != null && each.value.cpu.sockets > 0, false) ? each.value.cpu.sockets : var.machine.global.cpu.sockets
#         type = try(each.value.cpu.type != null, false) ? each.value.cpu.type : var.machine.global.cpu.type
#         units = try(each.value.cpu.units != null && each.value.cpu.units > 0, false) ? each.value.cpu.units : var.machine.global.cpu.units
#         # affinity = try(each.value.cpu.affinity != null && each.value.cpu.affinity > 0, false) ? each.value.cpu.affinity : var.machine.global.cpu.affinity
#     }

#     description = try(each.value.description != null, false) ? each.value.description : var.machine.global.description

#     disk {
#         aio = try(each.value.disk.aio != null, false) ? each.value.disk.aio : var.machine.global.disk.aio
#         backup = try(each.value.disk.backup != null, false) ? each.value.disk.backup : var.machine.global.disk.backup
#         cache = try(each.value.disk.cache != null, false) ? each.value.disk.cache : var.machine.global.disk.cache
#         datastore_id = var.terraform.proxmox.datastore_id.disk
#         discard = try(each.value.disk.discard != null, false) ? each.value.disk.discard : var.machine.global.disk.discard
#         file_format = try(each.value.disk.file_format != null, false) ? each.value.disk.file_format : var.machine.global.disk.file_format
#         file_id = proxmox_virtual_environment_download_file.cloud.id
#         interface = try(each.value.disk.interface != null, false) ? each.value.disk.interface : var.machine.global.disk.interface
#         iothread = try(each.value.disk.iothread != null, false) ? each.value.disk.iothread : var.machine.global.disk.iothread
#         replicate = try(each.value.disk.replicate != null, false) ? each.value.disk.replicate : var.machine.global.disk.replicate
#         # serial = try(each.value.disk.serial != null, false) ? each.value.disk.serial : var.machine.global.disk.serial
#         size = try(each.value.disk.size != null && each.value.disk.size > 0, false) ? each.value.disk.size : var.machine.global.disk.size
#         ssd = try(each.value.disk.ssd != null, false) ? each.value.disk.ssd : var.machine.global.disk.ssd
#     }

#     # efi_disk {
#     #     datastore_id = var.terraform.proxmox.datastore_id.disk
#     #     file_format = try(each.value.efi_disk.file_format != null, false) ? each.value.efi_disk.file_format : var.machine.global.efi_disk.file_format
#     #     type = try(each.value.efi_disk.type != null, false) ? each.value.efi_disk.type : var.machine.global.efi_disk.type
#     #     pre_enrolled_keys = try(each.value.efi_disk.pre_enrolled_keys != null, false) ? each.value.efi_disk.pre_enrolled_keys : var.machine.global.efi_disk.pre_enrolled_keys
#     # }

#     initialization {
#         datastore_id = var.terraform.proxmox.datastore_id.disk
#         user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
        
#         ip_config {
#             ipv4 {
#                 address = try(each.value.ipv4.address != null, false) ? "${each.value.ipv4.address}/24" : var.machine.global.ipv4.address
#                 gateway = try(each.value.ipv4.gateway != null, false) ? each.value.ipv4.gateway : var.machine.global.ipv4.gateway
#             }
#             ipv6 {
#                 address = try(each.value.ipv6.address != null, false) ? each.value.ipv6.address : var.machine.global.ipv6.address
#                 # gateway = try(each.value.ipv6.gateway != null, false) ? each.value.ipv6.gateway : var.machine.global.ipv6.gateway
#             }
#         }
#     }

#     machine = try(each.value.machine != null, false) ? each.value.machine : var.machine.global.machine

#     memory {
#         dedicated = try(each.value.memory.dedicated != null && each.value.disk.size > 0, false) ? each.value.memory.dedicated : var.machine.global.memory.dedicated
#         floating = try(each.value.memory.floating != null && each.value.disk.size > 0, false) ? each.value.memory.floating : var.machine.global.memory.floating
#         shared = try(each.value.memory.shared != null && each.value.disk.size > 0, false) ? each.value.memory.shared : var.machine.global.memory.shared
#     }

#     name = try(each.value.name != null, false) ? each.value.name : var.machine.global.name

#     network_device {
#         bridge = try(each.value.network_device.bridge != null, false) ? each.value.network_device.bridge : var.machine.global.network_device.bridge
#         disconnected = try(each.value.network_device.disconnected != null, false) ? each.value.network_device.disconnected : var.machine.global.network_device.disconnected
#         enabled = try(each.value.network_device.enabled != null, false) ? each.value.network_device.enabled : var.machine.global.network_device.enabled
#         firewall = try(each.value.network_device.firewall != null, false) ? each.value.network_device.firewall : var.machine.global.network_device.firewall
#         mac_address = each.value.network_device.mac_address
#         model = try(each.value.network_device.model != null, false) ? each.value.network_device.model : var.machine.global.network_device.model
#     }

#     on_boot = try(each.value.on_boot != null, false) ? each.value.on_boot : var.machine.global.on_boot

#     operating_system {
#         type = try(each.value.operating_system.type != null, false) ? each.value.operating_system.type : var.machine.global.operating_system.type
#     }

#     started = try(each.value.started != null, false) ? each.value.started : var.machine.global.started

#     startup {
#         order = try(each.value.startup.order != null && each.value.disk.size > 0, false) ? each.value.startup.order : var.machine.global.startup.order
#         up_delay = try(each.value.startup.up_delay != null && each.value.disk.size > 0, false) ? each.value.startup.up_delay : var.machine.global.startup.up_delay
#         down_delay = try(each.value.startup.down_delay != null && each.value.disk.size > 0, false) ? each.value.startup.down_delay : var.machine.global.startup.down_delay
#     }

#     tags = try(each.value.tags != null, false) ? each.value.tags : var.machine.global.tags

#     stop_on_destroy = try(each.value.stop_on_destroy != null, false) ? each.value.stop_on_destroy : var.machine.global.stop_on_destroy

#     vga {
#         memory = try(each.value.vga.memory != null && each.value.disk.size > 0, false) ? each.value.vga.memory : var.machine.global.vga.memory
#         type = try(each.value.vga.type != null, false) ? each.value.vga.type : var.machine.global.vga.type
#         clipboard = try(each.value.vga.clipboard != null, false) ? each.value.vga.clipboard : var.machine.global.vga.clipboard
#     }

#     vm_id = each.value.vm_id
# }

# resource "null_resource" "exec_required" {
#     for_each = { for idx, machine in var.machine.required : idx => machine }

#     depends_on = [
#         proxmox_virtual_environment_vm.required
#     ]

#     triggers = {
#         always_run = timestamp()
#     }
  
#     connection {
#         type = "ssh"
#         user = var.machine.global.username
#         private_key = file(var.SSH_PRIVATE_KEY)
#         host = each.value.ipv4.address
#         port = 22
#     }

#     provisioner "remote-exec" {
#         inline = concat(
#             [
#                 "sudo hostnamectl set-hostname ${each.value.name}",
#                 "sudo systemctl restart systemd-hostnamed"
#             ],
#             local.exec.inline.gitconfig,
#             local.exec.inline.private_key,
#             each.value.exec
#         )
#     }
# }
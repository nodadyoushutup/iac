resource "proxmox_virtual_environment_download_file" "image" {
    content_type = "iso"
    datastore_id = local.image.datastore_id
    node_name = local.image.node_name
    overwrite = local.image.overwrite
    overwrite_unmanaged = local.image.overwrite_unmanaged
    file_name = local.image.file_name
    url = local.image.url
}

resource "proxmox_virtual_environment_file" "cloud_config" {
    content_type = "snippets"
    datastore_id = local.cloud_config.datastore_id
    node_name = local.cloud_config.node_name

    source_raw {
        data = can(regex("talos", local.image.url)) ? local.template.talos : local.template.cloud
        file_name = local.cloud_config.file_name
    }
}

resource "proxmox_virtual_environment_vm" "virtual_machine" {
    depends_on = [
        proxmox_virtual_environment_download_file.image,
        proxmox_virtual_environment_file.cloud_config
    ]

    agent {
        enabled = local.agent.enabled
        timeout = local.agent.timeout
        trim = local.agent.trim
        type = local.agent.type
    }

    audio_device {
        device = local.audio_device.device
        driver = local.audio_device.driver
        enabled = local.audio_device.enabled
    }

    bios = local.bios

    boot_order = local.boot_order

    cpu {
        affinity = local.cpu.affinity
        cores = local.cpu.cores
        flags = local.cpu.flags
        hotplugged = local.cpu.hotplugged
        limit = local.cpu.limit
        numa = local.cpu.numa
        sockets = local.cpu.sockets
        type = local.cpu.type
        units = local.cpu.units
    }

    description = local.description

    disk {
        aio = local.disk.aio
        backup = local.disk.backup
        cache = local.disk.cache
        datastore_id = local.disk.datastore_id
        discard = local.disk.discard
        file_format = local.disk.file_format
        file_id = local.disk.file_id
        interface = local.disk.interface
        iothread = local.disk.iothread
        replicate = local.disk.replicate
        serial = local.disk.serial
        size = local.disk.size
        ssd = local.disk.ssd
    }

    efi_disk {
        datastore_id = local.efi_disk.datastore_id
        file_format = local.efi_disk.file_format
        type = local.efi_disk.type
        pre_enrolled_keys = local.efi_disk.pre_enrolled_keys
    }

    initialization {
        datastore_id = local.initialization.datastore_id
        user_data_file_id = local.initialization.user_data_file_id
        ip_config {
            ipv4 {
                address = (local.initialization.ip_config.ipv4.address != "dhcp"
                    ? "${local.initialization.ip_config.ipv4.address}/${local.initialization.ip_config.ipv4.cidr}" 
                    : local.initialization.ip_config.ipv4.address
                )
                gateway = local.initialization.ip_config.ipv4.gateway
            }
            ipv6 {
                address = local.initialization.ip_config.ipv6.address
                gateway = local.initialization.ip_config.ipv6.gateway
            }
        }
    }
                    
    machine = local.machine

    memory {
        dedicated = local.memory.dedicated
        floating = local.memory.floating
        shared = local.memory.shared
    }

    network_device {
        bridge = local.network_device.bridge
        disconnected = local.network_device.disconnected
        enabled = local.network_device.enabled
        firewall = local.network_device.firewall
        mac_address = local.network_device.mac_address
        model = local.network_device.model
    }

    name = local.name

    node_name = local.node_name

    on_boot = local.on_boot

    operating_system {
        type = local.operating_system.type
    }

    started = local.started

    startup {
        order = local.startup.order
        up_delay = local.startup.up_delay
        down_delay = local.startup.down_delay
    }

    tags = local.tag

    stop_on_destroy = local.stop_on_destroy

    vga {
        memory = local.vga.memory
        type = local.vga.type
        clipboard = local.vga.clipboard
    }

    vm_id = local.vm_id
}

locals {
  ipv4_addresses = flatten(proxmox_virtual_environment_vm.virtual_machine.ipv4_addresses)
}

output "debug" {
  value = local.ipv4_addresses
}

# resource "null_resource" "deploy_template" {
#     depends_on = [proxmox_virtual_environment_vm.virtual_machine]
#     provisioner "file" {
#         content = local.template.test
#         destination = "/tmp/test.txt"

#         connection {
#             type = "ssh"
#             host = proxmox_virtual_environment_vm.virtual_machine.ipv4_addresses[0]
#             user = local.cloud_config.auth.username
#             private_key = file("~/.ssh/id_rsa")
#         }
#     }

#     provisioner "remote-exec" {
#         inline = [
#             "mv /tmp/template.txt /remote/path/template.txt"
#         ]

#         connection {
#             type = "ssh"
#             host = proxmox_virtual_environment_vm.virtual_machine.ipv4_addresses[0]
#             user = local.cloud_config.auth.username
#             private_key = file("~/.ssh/id_rsa")
#         }
#     }
# }
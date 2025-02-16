resource "proxmox_virtual_environment_vm" "required" {
    for_each = { for idx, machine in var.machine.required : idx => machine }

    depends_on = [
        proxmox_virtual_environment_download_file.cloud,
        proxmox_virtual_environment_file.cloud_config
    ]
    
    node_name = var.terraform.proxmox.ssh.node.name

    agent {
        enabled = var.machine.global.agent.enabled
        timeout = var.machine.global.agent.timeout
        trim = var.machine.global.agent.trim
        type = var.machine.global.agent.type
    }

    audio_device {
        device = var.machine.global.audio_device.device
        driver = var.machine.global.audio_device.driver
        enabled = var.machine.global.audio_device.enabled
    }

    bios = var.machine.global.bios

    boot_order = var.machine.global.boot_order

    cpu {
        cores = try(each.value.cpu.cores != null && each.value.cpu.cores > 0, false) ? each.value.cpu.cores : var.machine.global.cpu.cores
        flags = var.machine.global.cpu.flags
        hotplugged = var.machine.global.cpu.hotplugged
        limit = var.machine.global.cpu.limit
        numa = var.machine.global.cpu.numa
        sockets = var.machine.global.cpu.sockets
        type = var.machine.global.cpu.type
        units = var.machine.global.cpu.units
        # affinity = var.machine.global.cpu.affinity
    }

    description = try(each.value.description != null, false) ? each.value.description : var.machine.global.description

    disk {
        aio = var.machine.global.disk.aio
        backup = var.machine.global.disk.backup
        cache = var.machine.global.disk.cache
        datastore_id = var.terraform.proxmox.datastore_id.disk
        discard = var.machine.global.disk.discard
        file_format = var.machine.global.disk.file_format
        file_id = proxmox_virtual_environment_download_file.cloud.id
        interface = var.machine.global.disk.interface
        iothread = var.machine.global.disk.iothread
        replicate = var.machine.global.disk.replicate
        # serial = var.machine.global.disk.serial
        size = try(each.value.disk.size != null && each.value.disk.size > 0, false) ? each.value.disk.size : var.machine.global.disk.size
        ssd = var.machine.global.disk.ssd
    }

    efi_disk {
        datastore_id = var.terraform.proxmox.datastore_id.disk
        file_format = var.machine.global.efi_disk.file_format
        type = var.machine.global.efi_disk.type
        pre_enrolled_keys = var.machine.global.efi_disk.pre_enrolled_keys
    }

    initialization {
        datastore_id = var.terraform.proxmox.datastore_id.disk
        user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
        
        ip_config {
            ipv4 {
                address = try(each.value.ipv4.address != null, false) ? "${each.value.ipv4.address}/24" : var.machine.global.ipv4.address
                gateway = try(each.value.ipv4.gateway != null, false) ? each.value.ipv4.gateway : var.machine.global.ipv4.gateway
            }
            ipv6 {
                address = try(each.value.ipv6.address != null, false) ? each.value.ipv6.address : var.machine.global.ipv6.address
                # gateway = try(each.value.ipv6.gateway != null, false) ? each.value.ipv6.gateway : var.machine.global.ipv6.gateway
            }
        }
    }

    machine = try(each.value.machine != null, false) ? each.value.machine : var.machine.global.machine

    memory {
        dedicated = try(each.value.memory.dedicated != null && each.value.disk.size > 0, false) ? each.value.memory.dedicated : var.machine.global.memory.dedicated
        floating = try(each.value.memory.floating != null && each.value.disk.size > 0, false) ? each.value.memory.floating : var.machine.global.memory.floating
        shared = try(each.value.memory.shared != null && each.value.disk.size > 0, false) ? each.value.memory.shared : var.machine.global.memory.shared
    }

    name = try(each.value.name != null, false) ? each.value.name : var.machine.global.name

    network_device {
        bridge = try(each.value.network_device.bridge != null, false) ? each.value.network_device.bridge : var.machine.global.network_device.bridge
        disconnected = try(each.value.network_device.disconnected != null, false) ? each.value.network_device.disconnected : var.machine.global.network_device.disconnected
        enabled = try(each.value.network_device.enabled != null, false) ? each.value.network_device.enabled : var.machine.global.network_device.enabled
        firewall = try(each.value.network_device.firewall != null, false) ? each.value.network_device.firewall : var.machine.global.network_device.firewall
        mac_address = each.value.network_device.mac_address
        model = try(each.value.network_device.model != null, false) ? each.value.network_device.model : var.machine.global.network_device.model
    }

    on_boot = try(each.value.on_boot != null, false) ? each.value.on_boot : var.machine.global.on_boot

    operating_system {
        type = try(each.value.operating_system.type != null, false) ? each.value.operating_system.type : var.machine.global.operating_system.type
    }

    started = try(each.value.started != null, false) ? each.value.started : var.machine.global.started

    startup {
        order    = 2
        up_delay = 0
        down_delay = 0
    }

    tags = ["gitops", "talos-worker"]

    stop_on_destroy = true

    vga {
        memory    = 16
        type      = "qxl"
        clipboard = "vnc"
    }

    vm_id = each.value.vm_id
}

resource "null_resource" "exec_required" {
    for_each = { for idx, machine in var.machine.required : idx => machine }

    depends_on = [
        proxmox_virtual_environment_vm.required
    ]

    triggers = {
        always_run = timestamp()
    }
  
    connection {
        type = "ssh"
        user = var.machine.global.username
        private_key = file(var.SSH_PRIVATE_KEY)
        host = each.value.ipv4.address
        port = 22
    }

    provisioner "remote-exec" {
        inline = concat(
            [
                "sudo hostnamectl set-hostname ${each.value.name}",
                "sudo systemctl restart systemd-hostnamed"
            ],
            local.exec.inline.gitconfig,
            local.exec.inline.private_key,
            each.value.exec
        )
    }
}
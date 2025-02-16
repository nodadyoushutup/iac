resource "proxmox_virtual_environment_vm" "required" {
    for_each = { for idx, machine in var.machine.required : idx => machine }

    depends_on = [
        proxmox_virtual_environment_download_file.talos_image,
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

    bios = "ovmf"

    boot_order = ["scsi0"]

    cpu {
        cores = each.value.cpu.cores
        flags = ["+aes"]
        hotplugged = 0
        limit = 0
        numa = false
        sockets = 1
        type = "x86-64-v2-AES"
        units = 1024
        affinity = null
    }

    description = each.value.name

    disk {
        aio = "io_uring"
        backup = true
        cache = "none"
        datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        discard = "on"
        file_format = "raw"
        file_id = proxmox_virtual_environment_download_file.cloud_image.id
        interface = "scsi0"
        iothread = false
        replicate = true
        serial = null
        size = each.value.disk.size
        ssd = true
    }

    efi_disk {
        datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        file_format = "raw"
        type = "4m"
        pre_enrolled_keys = false
    }

    initialization {
        datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
        
        ip_config {
            ipv4 {
                address = "${each.value.ipv4.address}/24"
                gateway = each.value.ipv4.gateway
            }
            ipv6 {
                address = "dhcp"
            }
        }
    }

    machine = "q35"

    memory {
        dedicated = each.value.memory.dedicated
        floating  = 0
        shared    = 0
    }

    name = each.value.name

    network_device {
        bridge = "vmbr0"
        disconnected = false
        enabled = true
        firewall = false
        mac_address = each.value.network_device.mac_address
        model = "virtio"
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    started = true

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
    for_each = { for idx, vm in var.machine.required : idx => vm }

    depends_on = [
        proxmox_virtual_environment_vm.required
    ]

    triggers = {
        always_run = timestamp()
    }
  
    connection {
        type = "ssh"
        user = var.VIRTUAL_MACHINE_GLOBAL_USERNAME
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
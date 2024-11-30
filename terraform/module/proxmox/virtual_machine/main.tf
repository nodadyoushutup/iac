resource "proxmox_virtual_environment_vm" "virtual_machine" {
    # REQUIRED
    node_name = local.config.proxmox.ssh.node.name

    # OPTIONAL
    name = var.name
    stop_on_destroy = var.stop_on_destroy
    vm_id = var.vm_id

    dynamic "agent" {
        for_each = var.agent != null ? [var.agent] : []
        content {
            enabled = agent.value.enabled
        }
    }

    dynamic "cpu" {
        for_each = var.cpu != null ? [var.cpu] : []
        content {
            cores = cpu.value.cores
            type = cpu.value.type
        }
    }

    dynamic "memory" {
        for_each = var.memory != null ? [var.memory] : []
        content {
            dedicated = memory.value.dedicated
        }
    }

    dynamic "disk" {
        for_each = var.disk != null ? [var.disk] : []
        content {
            datastore_id = disk.value.datastore_id
            file_id = disk.value.file_id
            interface = disk.value.interface
            discard = disk.value.discard
            size = disk.value.size
        }
    }

    initialization {
        ip_config {
            ipv4 {
                address = "dhcp"
            }
            ipv6 {
                address = "dhcp"
            }
        }
    }

    # network_device {
    #     bridge = "vmbr0"
    #     mac_address = "0a:00:00:00:11:02"
    # }

}


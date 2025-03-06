locals {
    agent_global = {
        enabled = try(var.config.proxmox.global.virtual_machine.agent.enabled, null)
        timeout = try(var.config.proxmox.global.virtual_machine.agent.timeout, null)
        trim = try(var.config.proxmox.global.virtual_machine.agent.trim, null)
        type = try(var.config.proxmox.global.virtual_machine.agent.type, null)
    }

    audio_device_global = {
        device = try(var.config.proxmox.global.virtual_machine.audio_device.device, null)
        driver = try(var.config.proxmox.global.virtual_machine.audio_device.driver, null)
        enabled = try(var.config.proxmox.global.virtual_machine.audio_device.enabled, null)
    }

    bios_global = try(var.config.proxmox.global.virtual_machine.bios, null)

    boot_order_global = try(var.config.proxmox.global.virtual_machine.boot_order, null)

    cpu_global = {
        affinity = try(var.config.proxmox.global.virtual_machine.cpu.affinity, null)
        cores = try(var.config.proxmox.global.virtual_machine.cpu.cores, null)
        flags = try(var.config.proxmox.global.virtual_machine.cpu.flags, null)
        hotplugged = try(var.config.proxmox.global.virtual_machine.cpu.hotplugged, null)
        limit = try(var.config.proxmox.global.virtual_machine.cpu.limit, null)
        numa = try(var.config.proxmox.global.virtual_machine.cpu.numa, null)
        sockets = try(var.config.proxmox.global.virtual_machine.cpu.sockets, null)
        type = try(var.config.proxmox.global.virtual_machine.cpu.type, null)
        units = try(var.config.proxmox.global.virtual_machine.cpu.units, null)
    }

    description_global = try(var.config.proxmox.global.virtual_machine.description, null)
}
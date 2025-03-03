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
}
locals {
    agent_global = {
        enabled = try(var.config.proxmox.global.virtual_machine.agent.enabled, null)
        timeout = try(var.config.proxmox.global.virtual_machine.agent.timeout, null)
        trim = try(var.config.proxmox.global.virtual_machine.agent.trim, null)
        type = try(var.config.proxmox.global.virtual_machine.agent.type, null)
    }
}
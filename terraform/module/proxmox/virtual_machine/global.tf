locals {
    agent_global = {
        enabled = try(var.config.proxmox.global.agent.enabled, null)
        timeout = try(var.config.proxmox.global.agent.timeout, null)
        trim = try(var.config.proxmox.global.agent.trim, null)
        type = try(var.config.proxmox.global.agent.type, null)
    }
}
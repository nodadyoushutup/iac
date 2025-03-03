locals {
    agent_input = {
        enabled = try(var.agent.enabled, null)
        timeout = try(var.agent.timeout, null)
        trim = try(var.agent.trim, null)
        type = try(var.agent.type, null)
    }

    audio_device_input = {
        device = try(var.audio_device.device, null)
        driver = try(var.audio_device.driver, null)
        enabled = try(var.audio_device.enabled, null)
    }
}
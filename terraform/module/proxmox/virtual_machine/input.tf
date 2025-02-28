locals {
    agent_input = {
        enabled = try(var.agent.enabled, null)
        timeout = try(var.agent.timeout, null)
        trim = try(var.agent.trim, null)
        type = try(var.agent.type, null)
    }
}
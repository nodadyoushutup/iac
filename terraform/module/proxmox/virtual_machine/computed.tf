locals {
    virtual_machine = {
        agent_computed = {
            enabled = local.agent_input.enabled != null ? local.agent_input.enabled : local.agent_global.enabled != null ? local.agent_global.enabled : null
            timeout = local.agent_input.timeout != null ? local.agent_input.timeout : local.agent_global.timeout != null ? local.agent_global.timeout : null
            trim = local.agent_input.trim != null ? local.agent_input.trim : local.agent_global.trim != null ? local.agent_global.trim : null
            type = local.agent_input.type != null ? local.agent_input.type : local.agent_global.type != null ? local.agent_global.type : null
        }
    }
}
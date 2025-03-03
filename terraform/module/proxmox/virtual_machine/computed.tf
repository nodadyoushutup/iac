locals {
    virtual_machine = {
        agent_computed = {
            enabled = local.agent_input.enabled != null ? local.agent_input.enabled : local.agent_global.enabled != null ? local.agent_global.enabled : null
            timeout = local.agent_input.timeout != null ? local.agent_input.timeout : local.agent_global.timeout != null ? local.agent_global.timeout : null
            trim = local.agent_input.trim != null ? local.agent_input.trim : local.agent_global.trim != null ? local.agent_global.trim : null
            type = local.agent_input.type != null ? local.agent_input.type : local.agent_global.type != null ? local.agent_global.type : null
        }

        audio_device_computed = {
            device = local.audio_device_input.device != null ? local.audio_device_input.device : local.audio_device_global.device != null ? local.audio_device_global.device : null
            driver = local.audio_device_input.driver != null ? local.audio_device_input.driver : local.audio_device_global.driver != null ? local.audio_device_global.driver : null
            enabled = local.audio_device_input.enabled != null ? local.audio_device_input.enabled : local.audio_device_global.enabled != null ? local.audio_device_global.enabled : null
        }

        bios_computed = local.bios_input != null ? local.bios_input : local.bios_global != null ? local.bios_global : null

        boot_order_computed = local.boot_order_input != null ? local.boot_order_input : local.boot_order_global != null ? local.boot_order_global : null
    }
}
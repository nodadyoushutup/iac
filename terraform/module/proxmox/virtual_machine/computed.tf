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

        cpu_computed = {
            affinity = local.cpu_input.affinity != null ? local.cpu_input.affinity : local.cpu_global.affinity != null ? local.cpu_global.affinity : null
            cores = local.cpu_input.cores != null ? local.cpu_input.cores : local.cpu_global.cores != null ? local.cpu_global.cores : null
            flags = local.cpu_input.flags != null ? local.cpu_input.flags : local.cpu_global.flags != null ? local.cpu_global.flags : null
            hotplugged = local.cpu_input.hotplugged != null ? local.cpu_input.hotplugged : local.cpu_global.hotplugged != null ? local.cpu_global.hotplugged : null
            limit = local.cpu_input.limit != null ? local.cpu_input.limit : local.cpu_global.limit != null ? local.cpu_global.limit : null
            numa = local.cpu_input.numa != null ? local.cpu_input.numa : local.cpu_global.numa != null ? local.cpu_global.numa : null
            sockets = local.cpu_input.sockets != null ? local.cpu_input.sockets : local.cpu_global.sockets != null ? local.cpu_global.sockets : null
            type = local.cpu_input.type != null ? local.cpu_input.type : local.cpu_global.type != null ? local.cpu_global.type : null
            units = local.cpu_input.units != null ? local.cpu_input.units : local.cpu_global.units != null ? local.cpu_global.units : null
        }

        description_computed = local.description_input != null ? local.description_input : local.description_global != null ? local.description_global : null
    }
}
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

        disk_computed = {
            aio = local.disk_input.aio != null ? local.disk_input.aio : local.disk_global.aio != null ? local.disk_global.aio : null
            backup = local.disk_input.backup != null ? local.disk_input.backup : local.disk_global.backup != null ? local.disk_global.backup : null
            cache = local.disk_input.cache != null ? local.disk_input.cache : local.disk_global.cache != null ? local.disk_global.cache : null
            datastore_id = local.disk_input.datastore_id != null ? local.disk_input.datastore_id : local.disk_global.datastore_id != null ? local.disk_global.datastore_id : null
            discard = local.disk_input.discard != null ? local.disk_input.discard : local.disk_global.discard != null ? local.disk_global.discard : null
            file_format = local.disk_input.file_format != null ? local.disk_input.file_format : local.disk_global.file_format != null ? local.disk_global.file_format : null
            file_id = local.disk_input.file_id != null ? local.disk_input.file_id : local.disk_global.file_id != null ? local.disk_global.file_id : module.image.image_id
            interface = local.disk_input.interface != null ? local.disk_input.interface : local.disk_global.interface != null ? local.disk_global.interface : null
            iothread = local.disk_input.iothread != null ? local.disk_input.iothread : local.disk_global.iothread != null ? local.disk_global.iothread : null
            replicate = local.disk_input.replicate != null ? local.disk_input.replicate : local.disk_global.replicate != null ? local.disk_global.replicate : null
            serial = local.disk_input.serial != null ? local.disk_input.serial : local.disk_global.serial != null ? local.disk_global.serial : null
            size = local.disk_input.size != null ? local.disk_input.size : local.disk_global.size != null ? local.disk_global.size : null
            ssd = local.disk_input.ssd != null ? local.disk_input.ssd : local.disk_global.ssd != null ? local.disk_global.ssd : null
        }

        machine_computed = local.machine_input != null ? local.machine_input : local.machine_global != null ? local.machine_global : null

        memory_computed = {
            dedicated = local.memory_input.dedicated != null ? local.memory_input.dedicated : local.memory_global.dedicated != null ? local.memory_global.dedicated : null
            floating = local.memory_input.floating != null ? local.memory_input.floating : local.memory_global.floating != null ? local.memory_global.floating : null
            shared = local.memory_input.shared != null ? local.memory_input.shared : local.memory_global.shared != null ? local.memory_global.shared : null
        }

        network_device_computed = {
            bridge = local.network_device_input.bridge != null ? local.network_device_input.bridge : local.network_device_global.bridge != null ? local.network_device_global.bridge : null
            disconnected = local.network_device_input.disconnected != null ? local.network_device_input.disconnected : local.network_device_global.disconnected != null ? local.network_device_global.disconnected : null
            enabled = local.network_device_input.enabled != null ? local.network_device_input.enabled : local.network_device_global.enabled != null ? local.network_device_global.enabled : null
            firewall = local.network_device_input.firewall != null ? local.network_device_input.firewall : local.network_device_global.firewall != null ? local.network_device_global.firewall : null
            mac_address = local.network_device_input.mac_address != null ? local.network_device_input.mac_address : local.network_device_global.mac_address != null ? local.network_device_global.mac_address : null
            model = local.network_device_input.model != null ? local.network_device_input.model : local.network_device_global.model != null ? local.network_device_global.model : null
        }

        node_name_computed = local.node_name_input != null ? local.node_name_input : local.node_name_global != null ? local.node_name_global : null

        on_boot_computed = local.on_boot_input != null ? local.on_boot_input : local.on_boot_global != null ? local.on_boot_global : null
    }
}
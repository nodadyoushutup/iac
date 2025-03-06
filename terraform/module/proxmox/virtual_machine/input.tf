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

    bios_input = try(var.bios, null)

    boot_order_input = try(var.boot_order, null)

    cpu_input = {
        affinity = try(var.cpu.affinity, null)
        cores = try(var.cpu.cores, null)
        flags = try(var.cpu.flags, null)
        hotplugged = try(var.cpu.hotplugged, null)
        limit = try(var.cpu.limit, null)
        numa = try(var.cpu.numa, null)
        sockets = try(var.cpu.sockets, null)
        type = try(var.cpu.type, null)
        units =try(var.cpu.units, null)
    }

    description_input = try(var.description, null)

    disk_input = {
        aio = try(var.disk.aio, null)
        backup = try(var.disk.backup, null)
        cache = try(var.disk.cache, null)
        datastore_id = try(var.disk.datastore_id, null)
        discard = try(var.disk.discard, null)
        file_format = try(var.disk.file_format, null)
        file_id = try(var.disk.file_id, null)
        interface = try(var.disk.interface, null)
        iothread = try(var.disk.iothread, null)
        replicate = try(var.disk.replicate, null)
        serial = try(var.disk.serial, null)
        size = try(var.disk.size, null)
        ssd = try(var.disk.ssd, null)
    }

    machine_input = try(var.machine, null)

    memory_input = {
        dedicated = try(var.memory.dedicated, null)
        floating = try(var.memory.floating, null)
        shared = try(var.memory.shared, null)
    }

    network_device_input = {
        bridge = try(var.network_device.bridge, null)
        disconnected = try(var.network_device.disconnected, null)
        enabled = try(var.network_device.enabled, null)
        firewall = try(var.network_device.firewall, null)
        mac_address = try(var.network_device.mac_address, null)
        model = try(var.network_device.model, null)
    }

    node_name_input = try(var.node_name, null)

    on_boot_input = try(var.on_boot, null)

    operating_system_input = {
        type = try(var.operating_system.type, null)
    }

    started_input = try(var.started, null)

    startup_input = {
        order = try(var.startup.order, null)
        up_delay = try(var.startup.up_delay, null)
        down_delay = try(var.startup.down_delay, null)
    }

    tags_input = try(var.tags, null)

    stop_on_destroy_input = try(var.stop_on_destroy, null)
}
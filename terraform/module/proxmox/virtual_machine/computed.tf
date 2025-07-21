locals {
  agent_computed = try(local.agent_input, null) != null || try(local.agent_global, null) != null ? {
    enabled = try(local.agent_input.enabled, null) != null ? try(local.agent_input.enabled, null) : try(local.agent_global.enabled, null) != null ? try(local.agent_global.enabled, null) : local.agent_default.enabled
    timeout = try(local.agent_input.timeout, null) != null ? try(local.agent_input.timeout, null) : try(local.agent_global.timeout, null) != null ? try(local.agent_global.timeout, null) : local.agent_default.timeout
    trim    = try(local.agent_input.trim, null) != null ? try(local.agent_input.trim, null) : try(local.agent_global.trim, null) != null ? try(local.agent_global.trim, null) : local.agent_default.trim
    type    = try(local.agent_input.type, null) != null ? try(local.agent_input.type, null) : try(local.agent_global.type, null) != null ? try(local.agent_global.type, null) : local.agent_default.type
  } : local.agent_default

  audio_device_computed = try(local.audio_device_input, null) != null || try(local.audio_device_global, null) != null ? {
    device  = try(local.audio_device_input.device, null) != null ? try(local.audio_device_input.device, null) : try(local.audio_device_global.device, null) != null ? try(local.audio_device_global.device, null) : local.audio_device_default.device
    driver  = try(local.audio_device_input.driver, null) != null ? try(local.audio_device_input.driver, null) : try(local.audio_device_global.driver, null) != null ? try(local.audio_device_global.driver, null) : local.audio_device_default.driver
    enabled = try(local.audio_device_input.enabled, null) != null ? try(local.audio_device_input.enabled, null) : try(local.audio_device_global.enabled, null) != null ? try(local.audio_device_global.enabled, null) : local.audio_device_default.enabled
  } : local.audio_device_default

  bios_computed = local.bios_input != null ? local.bios_input : local.bios_global != null ? local.bios_global : null

  boot_order_computed = local.boot_order_input != null ? local.boot_order_input : local.boot_order_global != null ? local.boot_order_global : null

  cpu_computed = try(local.cpu_input, null) != null || try(local.cpu_global, null) != null ? {
    affinity   = try(local.cpu_input.affinity, null) != null ? try(local.cpu_input.affinity, null) : try(local.cpu_global.affinity, null) != null ? try(local.cpu_global.affinity, null) : null
    cores      = try(local.cpu_input.cores, null) != null ? try(local.cpu_input.cores, null) : try(local.cpu_global.cores, null) != null ? try(local.cpu_global.cores, null) : null
    flags      = try(local.cpu_input.flags, null) != null ? try(local.cpu_input.flags, null) : try(local.cpu_global.flags, null) != null ? try(local.cpu_global.flags, null) : null
    hotplugged = try(local.cpu_input.hotplugged, null) != null ? try(local.cpu_input.hotplugged, null) : try(local.cpu_global.hotplugged, null) != null ? try(local.cpu_global.hotplugged, null) : null
    limit      = try(local.cpu_input.limit, null) != null ? try(local.cpu_input.limit, null) : try(local.cpu_global.limit, null) != null ? try(local.cpu_global.limit, null) : null
    numa       = try(local.cpu_input.numa, null) != null ? try(local.cpu_input.numa, null) : try(local.cpu_global.numa, null) != null ? try(local.cpu_global.numa, null) : null
    sockets    = try(local.cpu_input.sockets, null) != null ? try(local.cpu_input.sockets, null) : try(local.cpu_global.sockets, null) != null ? try(local.cpu_global.sockets, null) : null
    type       = try(local.cpu_input.type, null) != null ? try(local.cpu_input.type, null) : try(local.cpu_global.type, null) != null ? try(local.cpu_global.type, null) : null
    units      = try(local.cpu_input.units, null) != null ? try(local.cpu_input.units, null) : try(local.cpu_global.units, null) != null ? try(local.cpu_global.units, null) : null
  } : null

  description_computed = local.description_input != null ? local.description_input : local.description_global != null ? local.description_global : null

  disk_computed = local.disk_input != null || local.disk_global != null ? {
    aio          = try(local.disk_input.aio, null) != null ? try(local.disk_input.aio, null) : try(local.disk_global.aio, null) != null ? try(local.disk_global.aio, null) : local.disk_default.aio
    backup       = try(local.disk_input.backup, null) != null ? try(local.disk_input.backup, null) : try(local.disk_global.backup, null) != null ? try(local.disk_global.backup, null) : local.disk_default.backup
    cache        = try(local.disk_input.cache, null) != null ? try(local.disk_input.cache, null) : try(local.disk_global.cache, null) != null ? try(local.disk_global.cache, null) : local.disk_default.cache
    datastore_id = try(local.disk_input.datastore_id, null) != null ? try(local.disk_input.datastore_id, null) : try(local.disk_global.datastore_id, null) != null ? try(local.disk_global.datastore_id, null) : local.disk_default.datastore_id
    discard      = try(local.disk_input.discard, null) != null ? try(local.disk_input.discard, null) : try(local.disk_global.discard, null) != null ? try(local.disk_global.discard, null) : local.disk_default.discard
    file_format  = try(local.disk_input.file_format, null) != null ? try(local.disk_input.file_format, null) : try(local.disk_global.file_format, null) != null ? try(local.disk_global.file_format, null) : local.disk_default.file_format
    file_id      = try(local.disk_input.file_id, null) != null ? try(local.disk_input.file_id, null) : try(local.disk_global.file_id, null) != null ? try(local.disk_global.file_id, null) : local.disk_default.file_id
    interface    = try(local.disk_input.interface, null) != null ? try(local.disk_input.interface, null) : try(local.disk_global.interface, null) != null ? try(local.disk_global.interface, null) : local.disk_default.interface
    iothread     = try(local.disk_input.iothread, null) != null ? try(local.disk_input.iothread, null) : try(local.disk_global.iothread, null) != null ? try(local.disk_global.iothread, null) : local.disk_default.iothread
    replicate    = try(local.disk_input.replicate, null) != null ? try(local.disk_input.replicate, null) : try(local.disk_global.replicate, null) != null ? try(local.disk_global.replicate, null) : local.disk_default.replicate
    serial       = try(local.disk_input.serial, null) != null ? try(local.disk_input.serial, null) : try(local.disk_global.serial, null) != null ? try(local.disk_global.serial, null) : local.disk_default.serial
    size         = try(local.disk_input.size, null) != null ? try(local.disk_input.size, null) : try(local.disk_global.size, null) != null ? try(local.disk_global.size, null) : local.disk_default.size
    ssd          = try(local.disk_input.ssd, null) != null ? try(local.disk_input.ssd, null) : try(local.disk_global.ssd, null) != null ? try(local.disk_global.ssd, null) : local.disk_default.ssd
  } : local.disk_default

  machine_computed = local.machine_input != null ? local.machine_input : local.machine_global != null ? local.machine_global : null

  memory_computed = try(local.memory_input, null) != null || try(local.memory_global, null) != null ? {
    dedicated = try(local.memory_input.dedicated, null) != null ? try(local.memory_input.dedicated, null) : try(local.memory_global.dedicated, null) != null ? try(local.memory_global.dedicated, null) : null
    floating  = try(local.memory_input.floating, null) != null ? try(local.memory_input.floating, null) : try(local.memory_global.floating, null) != null ? try(local.memory_global.floating, null) : null
    shared    = try(local.memory_input.shared, null) != null ? try(local.memory_input.shared, null) : try(local.memory_global.shared, null) != null ? try(local.memory_global.shared, null) : null
  } : null

  network_device_computed = try(local.network_device_input, null) != null || try(local.network_device_global, null) != null ? {
    bridge       = try(local.network_device_input.bridge, null) != null ? try(local.network_device_input.bridge, null) : try(local.network_device_global.bridge, null) != null ? try(local.network_device_global.bridge, null) : null
    disconnected = try(local.network_device_input.disconnected, null) != null ? try(local.network_device_input.disconnected, null) : try(local.network_device_global.disconnected, null) != null ? try(local.network_device_global.disconnected, null) : null
    enabled      = try(local.network_device_input.enabled, null) != null ? try(local.network_device_input.enabled, null) : try(local.network_device_global.enabled, null) != null ? try(local.network_device_global.enabled, null) : null
    firewall     = try(local.network_device_input.firewall, null) != null ? try(local.network_device_input.firewall, null) : try(local.network_device_global.firewall, null) != null ? try(local.network_device_global.firewall, null) : null
    mac_address  = try(local.network_device_input.mac_address, null) != null ? try(local.network_device_input.mac_address, null) : try(local.network_device_global.mac_address, null) != null ? try(local.network_device_global.mac_address, null) : null
    model        = try(local.network_device_input.model, null) != null ? try(local.network_device_input.model, null) : try(local.network_device_global.model, null) != null ? try(local.network_device_global.model, null) : null
  } : null

  node_name_computed = local.node_name_input != null ? local.node_name_input : local.node_name_global != null ? local.node_name_global : null

  on_boot_computed = local.on_boot_input != null ? local.on_boot_input : local.on_boot_global != null ? local.on_boot_global : null

  operating_system_computed = try(local.operating_system_input, null) != null || try(local.operating_system_global, null) != null ? {
    type = try(local.operating_system_input.type, null) != null ? try(local.operating_system_input.type, null) : try(local.operating_system_global.type, null) != null ? try(local.operating_system_global.type, null) : null
  } : null

  started_computed = local.started_input != null ? local.started_input : local.started_global != null ? local.started_global : null

  startup_computed = try(local.startup_input, null) != null || try(local.startup_global, null) != null ? {
    order      = try(local.startup_input.order, null) != null ? try(local.startup_input.order, null) : try(local.startup_global.order, null) != null ? try(local.startup_global.order, null) : null
    up_delay   = try(local.startup_input.up_delay, null) != null ? try(local.startup_input.up_delay, null) : try(local.startup_global.up_delay, null) != null ? try(local.startup_global.up_delay, null) : null
    down_delay = try(local.startup_input.down_delay, null) != null ? try(local.startup_input.down_delay, null) : try(local.startup_global.down_delay, null) != null ? try(local.startup_global.down_delay, null) : null
  } : null

  tags_computed = local.tags_input != null ? local.tags_input : local.tags_global != null ? local.tags_global : null

  stop_on_destroy_computed = local.stop_on_destroy_input != null ? local.stop_on_destroy_input : local.stop_on_destroy_global != null ? local.stop_on_destroy_global : null

  vga_computed = try(local.vga_input, null) != null || try(local.vga_global, null) != null ? {
    memory    = try(local.vga_input.memory, null) != null ? try(local.vga_input.memory, null) : try(local.vga_global.memory, null) != null ? try(local.vga_global.memory, null) : null
    type      = try(local.vga_input.type, null) != null ? try(local.vga_input.type, null) : try(local.vga_global.type, null) != null ? try(local.vga_global.type, null) : null
    clipboard = try(local.vga_input.clipboard, null) != null ? try(local.vga_input.clipboard, null) : try(local.vga_global.clipboard, null) != null ? try(local.vga_global.clipboard, null) : null
  } : null

  vm_id_computed = local.vm_id_input != null ? local.vm_id_input : null # No global available
}

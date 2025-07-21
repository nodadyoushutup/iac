locals {
  agent_global = try(var.config.proxmox.global.virtual_machine.agent, null) != null ? {
    enabled = try(var.config.proxmox.global.virtual_machine.agent.enabled, null)
    timeout = try(var.config.proxmox.global.virtual_machine.agent.timeout, null)
    trim    = try(var.config.proxmox.global.virtual_machine.agent.trim, null)
    type    = try(var.config.proxmox.global.virtual_machine.agent.type, null)
  } : null

  audio_device_global = try(var.config.proxmox.global.virtual_machine.audio_device, null) != null ? {
    device  = try(var.config.proxmox.global.virtual_machine.audio_device.device, null)
    driver  = try(var.config.proxmox.global.virtual_machine.audio_device.driver, null)
    enabled = try(var.config.proxmox.global.virtual_machine.audio_device.enabled, null)
  } : null

  bios_global = try(var.config.proxmox.global.virtual_machine.bios, null)

  boot_order_global = try(var.config.proxmox.global.virtual_machine.boot_order, null)

  cpu_global = try(var.config.proxmox.global.virtual_machine.cpu, null) != null ? {
    affinity   = try(var.config.proxmox.global.virtual_machine.cpu.affinity, null)
    cores      = try(var.config.proxmox.global.virtual_machine.cpu.cores, null)
    flags      = try(var.config.proxmox.global.virtual_machine.cpu.flags, null)
    hotplugged = try(var.config.proxmox.global.virtual_machine.cpu.hotplugged, null)
    limit      = try(var.config.proxmox.global.virtual_machine.cpu.limit, null)
    numa       = try(var.config.proxmox.global.virtual_machine.cpu.numa, null)
    sockets    = try(var.config.proxmox.global.virtual_machine.cpu.sockets, null)
    type       = try(var.config.proxmox.global.virtual_machine.cpu.type, null)
    units      = try(var.config.proxmox.global.virtual_machine.cpu.units, null)
  } : null

  description_global = try(var.config.proxmox.global.virtual_machine.description, null)

  disk_global = try(var.config.proxmox.global.virtual_machine.disk, null) != null ? {
    aio          = try(var.config.proxmox.global.virtual_machine.disk.aio, null)
    backup       = try(var.config.proxmox.global.virtual_machine.disk.backup, null)
    cache        = try(var.config.proxmox.global.virtual_machine.disk.cache, null)
    datastore_id = try(var.config.proxmox.global.virtual_machine.disk.datastore_id, null)
    discard      = try(var.config.proxmox.global.virtual_machine.disk.discard, null)
    file_format  = try(var.config.proxmox.global.virtual_machine.disk.file_format, null)
    file_id      = try(var.config.proxmox.global.virtual_machine.disk.file_id, null)
    interface    = try(var.config.proxmox.global.virtual_machine.disk.interface, null)
    iothread     = try(var.config.proxmox.global.virtual_machine.disk.iothread, null)
    replicate    = try(var.config.proxmox.global.virtual_machine.disk.replicate, null)
    serial       = try(var.config.proxmox.global.virtual_machine.disk.serial, null)
    size         = try(var.config.proxmox.global.virtual_machine.disk.size, null)
    ssd          = try(var.config.proxmox.global.virtual_machine.disk.ssd, null)
  } : null

  machine_global = try(var.config.proxmox.global.virtual_machine.machine, null)

  memory_global = try(var.config.proxmox.global.virtual_machine.memory, null) != null ? {
    dedicated = try(var.config.proxmox.global.virtual_machine.memory.dedicated, null)
    floating  = try(var.config.proxmox.global.virtual_machine.memory.floating, null)
    shared    = try(var.config.proxmox.global.virtual_machine.memory.shared, null)
  } : null

  network_device_global = try(var.config.proxmox.global.virtual_machine.network_device, null) != null ? {
    bridge       = try(var.config.proxmox.global.virtual_machine.network_device.bridge, null)
    disconnected = try(var.config.proxmox.global.virtual_machine.network_device.disconnected, null)
    enabled      = try(var.config.proxmox.global.virtual_machine.network_device.enabled, null)
    firewall     = try(var.config.proxmox.global.virtual_machine.network_device.firewall, null)
    mac_address  = try(var.config.proxmox.global.virtual_machine.network_device.mac_address, null)
    model        = try(var.config.proxmox.global.virtual_machine.network_device.model, null)
  } : null

  node_name_global = try(var.config.proxmox.global.virtual_machine.node_name, null)

  on_boot_global = try(var.config.proxmox.global.virtual_machine.on_boot, null)

  operating_system_global = try(var.config.proxmox.global.virtual_machine.operating_system, null) != null ? {
    type = try(var.config.proxmox.global.virtual_machine.operating_system.type, null)
  } : null

  started_global = try(var.config.proxmox.global.virtual_machine.started, null)

  startup_global = try(var.config.proxmox.global.virtual_machine.startup, null) != null ? {
    order      = try(var.config.proxmox.global.virtual_machine.startup.order, null)
    up_delay   = try(var.config.proxmox.global.virtual_machine.startup.up_delay, null)
    down_delay = try(var.config.proxmox.global.virtual_machine.startup.down_delay, null)
  } : null

  tags_global = try(var.config.proxmox.global.virtual_machine.tags, null)

  stop_on_destroy_global = try(var.config.proxmox.global.virtual_machine.stop_on_destroy, null)

  vga_global = try(var.config.proxmox.global.virtual_machine.vga, null) != null ? {
    memory    = try(var.config.proxmox.global.virtual_machine.vga.memory, null)
    type      = try(var.config.proxmox.global.virtual_machine.vga.type, null)
    clipboard = try(var.config.proxmox.global.virtual_machine.vga.clipboard, null)
  } : null
}
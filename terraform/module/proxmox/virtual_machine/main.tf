module "cloud_init" {
  source = "../cloud_init"

  config       = try(var.cloud_init.config, var.config)
  name         = try(var.name, "fallback")
  datastore_id = try(var.cloud_init.datastore_id, null)
  node_name    = try(var.cloud_init.node_name, null)
  overwrite    = try(var.cloud_init.overwrite, null)

  network     = try(var.cloud_init.network, null)
  bootcmd     = try(var.cloud_init.bootcmd, null)
  runcmd      = try(var.cloud_init.runcmd, null)
  mounts      = try(var.cloud_init.mounts, null)
  users       = try(var.cloud_init.users, null)
  groups      = try(var.cloud_init.groups, null)
  gitconfig   = try(var.cloud_init.gitconfig, null)
  write_files = try(var.cloud_init.write_files, null)
}

module "image" {
  source = "../image"

  config = var.config
  name = try(var.name, "fallback")
  datastore_id = try(var.cloud_init.datastore_id, null)
}

resource "proxmox_virtual_environment_vm" "virtual_machine" {
  depends_on = [
    module.cloud_init,
    module.image,
  ]

  agent {
    enabled = local.agent_computed.enabled
    timeout = "5m"
    trim    = local.agent_computed.trim
    type    = local.agent_computed.type
  }

  # audio_device {
  #   device  = local.audio_device_computed.device
  #   driver  = local.audio_device_computed.driver
  #   enabled = local.audio_device_computed.enabled
  # }

  bios       = "seabios"
  boot_order = local.boot_order_computed

  cpu {
    affinity   = local.cpu_computed.affinity
    cores      = local.cpu_computed.cores
    flags      = local.cpu_computed.flags
    hotplugged = local.cpu_computed.hotplugged
    limit      = local.cpu_computed.limit
    numa       = local.cpu_computed.numa
    sockets    = local.cpu_computed.sockets
    type       = local.cpu_computed.type
    units      = local.cpu_computed.units
  }

  description = local.description_computed

  disk {
    aio          = local.disk_computed.aio
    backup       = local.disk_computed.backup
    cache        = local.disk_computed.cache
    datastore_id = local.disk_computed.datastore_id
    discard      = local.disk_computed.discard
    file_format  = local.disk_computed.file_format
    file_id      = local.disk_computed.file_id
    interface    = local.disk_computed.interface
    iothread     = local.disk_computed.iothread
    replicate    = local.disk_computed.replicate
    serial       = local.disk_computed.serial
    size         = local.disk_computed.size
    ssd          = local.disk_computed.ssd
  }

  initialization {
    user_data_file_id    = module.cloud_init.cloud_id
    network_data_file_id = module.cloud_init.network_id
  }

  machine = local.machine_computed

  memory {
    dedicated = local.memory_computed.dedicated
    floating  = local.memory_computed.floating
    shared    = local.memory_computed.shared
  }

  network_device {
    bridge       = local.network_device_computed.bridge
    disconnected = local.network_device_computed.disconnected
    enabled      = local.network_device_computed.enabled
    firewall     = local.network_device_computed.firewall
    mac_address  = local.network_device_computed.mac_address
    model        = local.network_device_computed.model
  }

  node_name = local.node_name_computed
  on_boot   = local.on_boot_computed

  operating_system {
    type = local.operating_system_computed.type
  }

  started = local.started_computed

  startup {
    order      = local.startup_computed.order
    up_delay   = local.startup_computed.up_delay
    down_delay = local.startup_computed.down_delay
  }

  tags            = local.tags_computed
  stop_on_destroy = local.stop_on_destroy_computed

  vga {
    memory    = local.vga_computed.memory
    type      = local.vga_computed.type
    clipboard = local.vga_computed.clipboard
  }

  vm_id = local.vm_id_computed
  name  = try(var.name, "fallback")
}

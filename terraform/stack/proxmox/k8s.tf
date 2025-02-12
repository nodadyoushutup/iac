resource "proxmox_virtual_environment_vm" "talos_cp_1" {
    depends_on = [
        proxmox_virtual_environment_download_file.talos_image,
        proxmox_virtual_environment_file.cloud_config
    ]
    
    # REQUIRED
    ################################################
    node_name = var.PROXMOX_VE_SSH_NODE_NAME

    # OPTIONAL
    ################################################

    agent {
        enabled = true
        timeout = "5m"
        trim = false
        type = "virtio"
    }

    audio_device {
        device = "intel-hda"
        driver = "spice"
        enabled = true
    }

    bios = "ovmf"

    boot_order = ["scsi0"]

    cpu {
        # architecture = "x86_64" # Can only be set running terraform as root
        cores = 2
        flags = ["+aes"]
        hotplugged = 0
        limit = 0
        numa = false
        sockets = 1
        type = "x86-64-v2-AES"
        units = 1024
        affinity = null
    }

    description = "docker"

    disk {
        aio = "io_uring"
        backup = true
        cache = "none"
        datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        path_in_datastore = null
        discard = "on"
        file_format = "raw"
        file_id = proxmox_virtual_environment_download_file.talos_image.id
        interface = "scsi0"
        iothread = false
        replicate = true
        serial = null
        size = 20
        # speed = {
        #     iops_read = null 
        #     iops_read_burstable = null
        #     iops_write = null
        #     iops_write_burstable = null
        #     read = null
        #     read_burstable = null
        #     write = null
        #     write_burstable = null
        # }
        ssd = true
    }

    efi_disk {
        datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        file_format = "raw"
        type = "4m"
        pre_enrolled_keys = false
    }

    # initialization {
    #     datastore_id = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
    #     # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
        
    #     ip_config {
    #         ipv4 {
    #             address = "dhcp"
    #             gateway = var.VIRTUAL_MACHINE_GLOBAL_GATEWAY
    #         }
    #         ipv6 {
    #             address = "dhcp"
    #         }
    #     }
    # }

    machine = "q35"

    memory {
        dedicated = 4096
        floating = 0
        shared = 0
        hugepages = null
        keep_hugepages = null
    }

    name = "docker"

    network_device {
        bridge = "vmbr0"
        disconnected = false
        enabled = true
        firewall = false
        mac_address = "0a:00:00:00:12:00"
        model = "virtio"
        mtu = null
        queues = null
        rate_limit = null
        vlan_id = null
        trunks = null
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    # pool_id = "kubernetes"

    started = true

    startup {
        order = 2
        up_delay = 0
        down_delay = 0
    }

    tags = ["gitops"]

    stop_on_destroy = true

    vga {
        memory = 16
        type = "qxl"
        clipboard = "vnc"
    }

    vm_id = 1200
}
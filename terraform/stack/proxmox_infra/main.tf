module "virtual_machine_docker" {
    source  = "spacelift.io/nodadyoushutup/virtual-machine/proxmox"

    # REQUIRED
    ################################################
    node_name = "pve"

    # OPTIONAL
    ################################################
    agent = {
        enabled = true
        timeout = "5m"
        trim = false
        type = "virtio"
    }

    audio_device = {
        device = "intel-hda"
        driver = "spice"
        enabled = true
    }

    bios = "ovmf"

    boot_order = ["scsi0"]

    cpu = {
        architecture = "x86_64"
        cores = 2
        flags = ["+aes", "+hv-evmcs"]
        hotplugged = 0
        limit = 0
        numa = false
        sockets = 1
        type = "x86-64-v2-AES"
        units = 1024
        affinity = null
    }

    description = "module-debug"

    disk = {
        aio = "io_uring"
        backup = true
        cache = "none"
        datastore_id = "virtualization"
        path_in_datastore = null
        discard = "on"
        file_format = "raw"
        file_id = "local:iso/cloud_image_x86_64_jammy.img"
        interface = "scsi0"
        iothread = false
        replicate = true
        serial = null
        size = 10
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

    efi_disk = {
        datastore_id = "local-lvm"
        file_format = "raw"
        type = "4m"
        pre_enrolled_keys = false
    }

    tpm_state = {
        datastore_id = "local-lvm"
        version = "v2.0"
    }

    initialization = {
        ip_config = {
            ipv4 = {
                address = "dhcp"
            }
            ipv6 = {
                address = "dhcp"
            }
        }
        user_account = {
            password = "ubuntu"
            username = "ubuntu"
        }
    }

    machine = "q35"

    memory = {
        dedicated = 16384
        floating = 0
        shared = 0
        hugepages = null
        keep_hugepages = null
    }

    name = "module-debug"

    network_device = {
        bridge = "vmbr0"
        disconnected = false
        enabled = true
        firewall = false
        mac_address = "0a:00:00:00:11:02"
        model = "e1000e"
        mtu = null
        queues = null
        rate_limit = null
        vlan_id = null
        trunks = null
    }

    on_boot = true

    operating_system = {
        type = "l26"
    }

    pool_id = "cloud-image"

    startup = {
        order = 1
        up_delay = 0
        down_delay = 0
    }

    tags = ["terraform", "cloud-image"]

    stop_on_destroy = true

    vga = {
        memory = 16
        type = "qxl"
        clipboard = "vnc"
    }

    vm_id = 1102
}
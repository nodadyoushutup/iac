module "virtual_machine_docker" {
    source  = "spacelift.io/nodadyoushutup/virtual-machine/proxmox"

    # REQUIRED
    ################################################
    node_name = "pve"

    # OPTIONAL
    ################################################
    acpi = true

    agent = {
        enabled = true
        timeout = "5m"
        trim = false
        type = "virtio"
    }

    audio_device = {
        device = "intel-hda"
        driver = "spice"
        enabled = false
    }

    bios = "ovmf"

    boot_order = ["scsi0"]

    cdrom = {
        enabled = true
        file_id = "none"
        interface = "ide0"
    }

    clone = {
        datastore_id = "local-lvm"
        node_name = "pve"
        retries = 1
        vm_id = 900
        full = true
    }

    cpu = {
        architecture = "x86_64"
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

    description = "testing1234"

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
        serial = "SN123456789012345678"
        size = 10
        speed = {
            iops_read = null 
            iops_read_burstable = null
            iops_write = null
            iops_write_burstable = null
            read = null
            read_burstable = null
            write = null
            write_burstable = null
        }
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

    hostpci = {
        device = "hostpci0"
        id = "0000:01:00.0"
        mapping = null
        mdev = false
        pcie = false
        rombar = false
        rom_file = null
        xvga = true
    }

    usb = {
        host = "046d:c31d"
        mapping = null
        usb3 = true
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

    keyboard_layout = "en-us"

    kvm_arguments = "-cpu host"

    machine = "q35"

    memory = {
        dedicated = 8192
        floating = 0
        shared = 0
        hugepages = null
        keep_hugepages = null
    }

    # #TODO: NUMA configuration

    migrate = false

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

    pool_id = "debug"

    protection = false

    reboot = false

    serial_device = {
        device = "socket"
    }

    scsi_hardware = "virtio-scsi-pci"

    smbios = {
        family = "VirtualMachine"
        manufacturer = "TerraformProxmox"
        product = "ProxmoxVirtualMachine"
        serial = "SMB1234567890"
        sku = "TEST-VM-SKU"
        uuid = "123e4567-e89b-12d3-a456-426614174000"
        version = "1.0"
    }

    started = true

    startup = {
        order = 1
        up_delay = 15
        down_delay = 15
    }

    tablet_device = true

    tags = ["terraform", "cloud-image"]

    template = true

    stop_on_destroy = true

    timeout_clone = 330

    timeout_create = 330

    timeout_migrate = 330

    timeout_reboot = 330

    timeout_shutdown_vm = 330

    timeout_start_vm = 330

    timeout_stop_vm = 330

    vga = {
        memory = 16
        type = "qxl"
        clipboard = "vnc"
    }

    vm_id = 1102

    hook_script_file_id = null

    # #TODO: Watchdog
}
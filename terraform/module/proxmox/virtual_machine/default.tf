locals { # Default
    agent_default = {
        enabled = true
        timeout = "5m"
        trim = false
        type = "virtio"
    }

    audio_device_default = {
        device = null
        driver = null
        enabled = null
    }

    disk_default = {
        aio = "io_uring"
        backup = true
        cache = "none"
        datastore_id = "virtualization"
        discard = "on"
        file_format = "raw"
        file_id = module.image.image_id
        interface = "scsi0"
        iothread = false
        replicate = true
        serial = null
        size = 20
        ssd = true
    }   
}
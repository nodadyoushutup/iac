locals {
    base64 = {
        # config = try(
        #     filebase64(var.PATH_CONFIG), 
        #     filebase64("/mnt/workspace/source/config/default/config.yaml")
        # )
        private_key = try(
            filebase64(var.PROXMOX_VE_PRIVATE_KEY), 
            filebase64("/mnt/workspace/source/config/default/id_rsa")
        )
    }
    # flag = {
    #     deploy = var.FLAG_DEPLOY + 1
    #     config = var.FLAG_DEPLOY >= 1 && try(
    #         data.external.validate[0].result["valid"], 
    #         "false"
    #     ) == "true" ? var.FLAG_CONFIG + 1 : var.FLAG_CONFIG
    # }
    github = {
        branch = coalesce(var.GITHUB_BRANCH, data.spacelift_stack.spacelift.branch)
        repository = coalesce(var.GITHUB_REPOSITORY, data.spacelift_stack.spacelift.repository)
    }
    proxmox = {
        endpoint = var.PROXMOX_VE_ENDPOINT
        insecure = var.PROXMOX_VE_INSECURE
        username = var.PROXMOX_VE_USERNAME
        password = var.PROXMOX_VE_PASSWORD
        private_key = var.PROXMOX_VE_PRIVATE_KEY
    }
}
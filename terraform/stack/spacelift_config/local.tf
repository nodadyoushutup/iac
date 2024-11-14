locals {
    base64 = {
        config = try(
            filebase64(var.PATH_CONFIG), 
            filebase64("/mnt/workspace/source/config/default/config.yaml")
        )
        private_key = try(
            filebase64(var.PATH_PRIVATE_KEY), 
            filebase64("/mnt/workspace/source/config/default/id_rsa")
        )
    }
    flag = {
        deploy = var.FLAG_DEPLOY + 1
        config = var.FLAG_DEPLOY >= 1 && try(
            data.external.validate[0].result["valid"], 
            "false"
        ) == "true" ? var.FLAG_CONFIG + 1 : var.FLAG_CONFIG
    }
    git = {
        branch = coalesce(var.GIT_BRANCH, data.spacelift_stack.spacelift_config.branch)
        repository = coalesce(var.GIT_REPOSITORY, data.spacelift_stack.spacelift_config.repository)
    }
}
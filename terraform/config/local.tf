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
        pyvenv = var.FLAG_PYVENV == 2 ? var.FLAG_PYVENV : var.FLAG_PYVENV + 1
        config = try(
            var.FLAG_PYVENV == 2 
            && data.external.validate_env[0].result["valid"] == "true", null
        ) ? var.FLAG_CONFIG + 1 : var.FLAG_CONFIG
    }
    git = {
        branch = coalesce(var.GIT_BRANCH, data.spacelift_stack.config.branch)
        repository = coalesce(var.GIT_REPOSITORY, data.spacelift_stack.config.repository)
    }
}
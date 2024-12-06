locals {
    config = {
        path = var.CONFIG_PATH
        data = try(yamldecode(file("${path.module}/config.sub.yaml")), {})
        valid = data.external.validate.result["valid"] == "true" ? var.FLAG_VALID_CONFIG + 1 : 0
    }

    base64 = {
        private_key = try(
        filebase64(var.DEFAULT_PRIVATE_KEY), 
        filebase64("${path.module}/file/id_rsa")
        )
    }

    default = {
        private_key = var.DEFAULT_PRIVATE_KEY
        password = var.DEFAULT_PASSWORD
        ip_address = var.DEFAULT_IP_ADDRESS
    }

    flag = {
        deploy = var.FLAG_DEPLOY + 1
    }

    github = {
        branch = coalesce(var.GITHUB_BRANCH, data.spacelift_stack.spacelift.branch)
        repository = coalesce(var.GITHUB_REPOSITORY, data.spacelift_stack.spacelift.repository)
    }

    spacelift = {
        runner_image = var.SPACELIFT_RUNNER_IMAGE
    }
}
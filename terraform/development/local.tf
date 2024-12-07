locals {
    config = {
        path = var.CONFIG_PATH_CONFIG         
        data = try(yamldecode(file("${path.module}/config.sub.yaml")), {})
    }
    default = {
        private_key = var.DEFAULT_PRIVATE_KEY
        public_key_dir = var.DEFAULT_PUBLIC_KEY_DIR
        username = var.DEFAULT_USERNAME
        password = var.DEFAULT_PASSWORD
        ip_address = var.DEFAULT_IP_ADDRESS
        gateway = var.DEFAULT_GATEWAY
    }
    github = {
        branch = coalesce(var.GITHUB_BRANCH, data.spacelift_stack.spacelift.branch)
        repository = coalesce(var.GITHUB_REPOSITORY, data.spacelift_stack.spacelift.repository)
    }
}
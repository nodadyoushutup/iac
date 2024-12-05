locals {
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
        valid_config = var.FLAG_VALID_CONFIG
        deploy = var.FLAG_DEPLOY + 1
    }
    config = try(yamldecode(file("/mnt/workspace/config.yaml")))
}

output "debug" {
    value = local.flag
}
locals {
    config_path = "${path.module}/config/config.yaml"
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
    config = try(yamldecode(file("~/config.yaml")))
}
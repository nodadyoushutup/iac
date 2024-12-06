locals {
  config = {
        path = {
            config = var.CONFIG_PATH_CONFIG
            public_key = var.CONFIG_PATH_PUBLIC_KEY
        }
        data = try(yamldecode(file("${path.module}/config.sub.yaml")), {})
    }
}

output "debug" {
  value = local.config
}
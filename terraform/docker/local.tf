locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {})
  cloud_config = file("/mnt/workspace/cloud_config.yaml")
  cloud_config_debug = <<-EOF
${local.cloud_config}
EOF
}


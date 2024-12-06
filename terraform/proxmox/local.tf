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
  }
  public_key = fileset(local.config.data.default.public_key_dir, "*.pub")
  runcmd_base = ["echo 'Base cloud-config commands'"]
  runcmd = {
    docker = concat(local.runcmd_base, [
      "echo 'Docker runcmd' > /tmp/docker.txt"
    ])
  }
}

output "locals" {
  value = local.public_key
}
locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    path = {
      private_key     = "/mnt/workspace/source/default/id_rsa"
      inventory       = "/mnt/workspace/source/default/inventory"
      env             = "/mnt/workspace/source/default/.env"
      gitconfig       = "/mnt/workspace/source/config/.gitconfig"
      ansible         = "/mnt/workspace/source/config/ansible.cfg"
      prometheus      = "/mnt/workspace/source/config/prometheus.yaml"
      docker_compose  = "/mnt/workspace/source/config/docker-compose.yaml"
    }
  })
}
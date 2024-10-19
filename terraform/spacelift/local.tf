locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  git_config_path = try(var.GIT_CONFIG != null && var.GIT_CONFIG != "" ? var.GIT_CONFIG : "/mnt/workspace/.gitconfig")
  config = try(yamldecode(file(local.git_config_path)), {})
  config_base64 = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/config/default_config.yaml"))
  private_key_base64 = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/config/default_id_rsa"))
}
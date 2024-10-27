output "validate_private_key" {
  value = data.external.validate_private_key.result["valid"] == "true" ? local.env_msg.valid.private_key : local.env_msg.invalid.private_key
}

output "validate_gitconfig" {
  value = data.external.validate_gitconfig.result["valid"] == "true" ? local.env_msg.valid.gitconfig : local.env_msg.invalid.gitconfig
}

output "validate_docker_env" {
  value = data.external.validate_docker_env.result["valid"] == "true" ? local.env_msg.valid.docker.env : local.env_msg.invalid.docker.env
}

# output "env_valid_check" {
#   value = data.external.validate_env.result["valid"] == "true" ? "Environment configuration is valid" : "Environment configuration is not valid"
# }

output "validate_private_key" {
  value = data.external.validate_private_key.result["valid"] == "true" ? "Priavte key is valid" : "Priavte key is not valid"
}

output "validate_gitconfig" {
  value = data.external.validate_gitconfig.result["valid"] == "true" ? "Gitconfig is valid" : "Gitconfig is not valid"
}

output "validate_ansible_inventory" {
  value = data.external.validate_inventory.result["valid"] == "true" ? "Ansible inventory is valid" : "Ansible inventory is not valid"
}

output "validate_docker_env" {
  value = data.external.validate_env.result["valid"] == "true" ? "Docker env is valid" : "Docker env is not valid"
}
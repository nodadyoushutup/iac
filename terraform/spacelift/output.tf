# output "env_valid_check" {
#   value = data.external.validate_env.result["valid"] == "true" ? "Environment configuration is valid" : "Environment configuration is not valid"
# }

output "validate_private_key" {
  value = data.external.validate_private_key.result["valid"] == "true" ? "Priavte key is valid" : "Priavte key is not valid"
}
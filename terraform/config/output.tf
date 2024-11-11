# output "_validate_results" {
#   value = data.external.validate_env.result["valid"] != "false" ? "All validation checks have passed" : "Some validation checks failed"
# }

# output "validate_config_path" {
#   value = data.external.validate_env.result["config_path"]
# }

# output "validate_yaml" {
#   value = data.external.validate_env.result["yaml"]
# }

# output "validate_private_key" {
#   value = data.external.validate_env.result["private_key"]
# }
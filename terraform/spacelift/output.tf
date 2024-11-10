# output "validate_private_key" {
#   value = data.external.validate_private_key.result["valid"] == "true" ? local.env_msg.valid : local.env_msg.invalid
# }
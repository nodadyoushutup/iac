output "validate_private_key" {
  value = data.external.validate_private_key.result["valid"] == "true" ? local.env_msg.valid.private_key : local.env_msg.invalid.private_key
}
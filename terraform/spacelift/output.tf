output "_validate_results" {
  value = data.external.validate.result["valid"] != "false" ? "Deploment ${var.FLAG_DEPLOY} - Validation checks have passed" : "Deploment ${var.FLAG_DEPLOY} - Some validation checks failed"
}

output "validate_debug" {
  value = data.external.validate.result["debug"]
}

output "validate_config_path" {
  value = data.external.validate.result["config_path"]
}

output "validate_yaml" {
  value = data.external.validate.result["config_yaml_syntax"]
}

output "validate_default_private_key" {
  value = data.external.validate.result["default_private_key"]
}

output "validate_default_public_key_dir" {
  value = data.external.validate.result["default_public_key_dir"]
}

output "validate_username" {
  value = data.external.validate.result["default_username"]
}

output "validate_default_password" {
  value = data.external.validate.result["default_password"]
}

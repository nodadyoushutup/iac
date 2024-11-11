output "_validate_results" {
  value = var.FLAG_PYVENV == 1 ? (data.external.validate_env[0].result["valid"] != "false" ? "All validation checks have passed" : "Some validation checks failed") : null
}

output "validate_config_path" {
  value = var.FLAG_PYVENV == 1 ? data.external.validate_env[0].result["config_path"] : null
}

output "validate_yaml" {
  value = var.FLAG_PYVENV == 1 ? data.external.validate_env[0].result["yaml"] : null
}

output "validate_private_key" {
  value = var.FLAG_PYVENV == 1 ? data.external.validate_env[0].result["private_key"] : null
}

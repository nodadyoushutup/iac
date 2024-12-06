output "_validate_results" {
  # value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["valid"] != "false" ? "Deploment ${var.FLAG_DEPLOY} - Validation checks have passed" : "Deploment ${var.FLAG_DEPLOY} - Some validation checks failed" : null
  value = data.external.validate.result["valid"] != "false" ? "Deploment ${var.FLAG_DEPLOY} - Validation checks have passed" : "Deploment ${var.FLAG_DEPLOY} - Some validation checks failed"
}

output "validate_debug" {
  # value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["debug"] : null
  value = data.external.validate.result["debug"]
}

output "validate_config_path" {
  # value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["config_path"] : null
  value = data.external.validate.result["config_path"]
}

output "validate_yaml" {
  # value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["yaml"] : null
  value = data.external.validate.result["yaml"]
}

output "validate_private_key" {
  # value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["private_key"] : null
  value = data.external.validate.result["private_key"]
}

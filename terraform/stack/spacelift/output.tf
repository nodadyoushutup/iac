# output "_validate_results" {
#   value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["valid"] != "false" ? "Deploment ${var.FLAG_DEPLOY} - Validation checks have passed" : "Deploment ${var.FLAG_DEPLOY} - Some validation checks failed" : null
# }

# output "validate_debug" {
#   value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["debug"] : null
# }

# output "validate_config_path" {
#   value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["config_path"] : null
# }

# output "validate_yaml" {
#   value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["yaml"] : null
# }

# output "validate_private_key" {
#   value = var.FLAG_DEPLOY >= 1 ? data.external.validate[0].result["private_key"] : null
# }

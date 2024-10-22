output "valid_check" {
  value = data.external.validate_env.result["valid"] == "true" ? "Environment configuration is valid" : "Environment configuration is not valid"
}
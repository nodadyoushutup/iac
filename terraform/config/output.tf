output "_validate_results" {
  value = [for i in range(length(data.external.validate_env)) :
    data.external.validate_env[i].result["valid"] != "false" ? "All validation checks have passed" : "Some validation checks failed"
  ]
}

output "validate_config_path" {
  value = [for i in range(length(data.external.validate_env)) :
    data.external.validate_env[i].result["config_path"]
  ]
}

output "validate_yaml" {
  value = [for i in range(length(data.external.validate_env)) :
    data.external.validate_env[i].result["yaml"]
  ]
}

output "validate_private_key" {
  value = [for i in range(length(data.external.validate_env)) :
    data.external.validate_env[i].result["private_key"]
  ]
}

data "aws_s3_object" "config" {
  bucket = var.minio_config_bucket
  key = "iac_config.json"
}

# data "external" "ssh_keys" {
#   # Calls our python script to list, download, and process files from MinIO.
#   program = ["python3", "${path.module}/script/ssh_keys.py"]

#   # Pass all needed parameters in the query.
#   query = {
#     bucket = var.minio_config_bucket
#     endpoints = var.endpoints.s3
#     access_key = var.access_key
#     secret_key = var.secret_key
#     region = var.region
#     skip_credentials_validation = tostring(var.skip_credentials_validation)
#     skip_metadata_api_check = tostring(var.skip_metadata_api_check)
#     skip_region_validation = tostring(var.skip_region_validation)
#     use_path_style = tostring(var.use_path_style)
#     skip_requesting_account_id  = tostring(var.skip_requesting_account_id)
#   }
# }

locals {
  config = jsondecode(data.aws_s3_object.config.body)
  sensitive = data.external.sanitized_config.result.data
  # ssh_key = jsondecode(data.external.ssh_keys.result.data)
}

data "external" "sanitized_config" {
  program = ["python3", "${path.module}/script/sanitize.py"]

  query = {
    config = jsonencode(local.config)
  }
}

output "config" {
  value = local.config
  sensitive = true
}

output "sensitive" {
  value = local.sensitive
  sensitive = true
}

# output "ssh_key" {
#   value = local.ssh_key
#   sensitive = true
# }
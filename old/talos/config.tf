variable "ssh_private_key" {
    type = string
    default = null
}

data "terraform_remote_state" "config" {
  backend = "s3"

  config = {
    bucket = "terraform"
    key = "config.tfstate"
    region = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key
    endpoints = {
      s3 = var.endpoints.s3
    }
    skip_credentials_validation = var.skip_credentials_validation
    skip_metadata_api_check = var.skip_metadata_api_check
    skip_region_validation = var.skip_region_validation
    skip_requesting_account_id  = var.skip_requesting_account_id
    use_path_style = var.use_path_style
  }
}

locals {
  config = data.terraform_remote_state.config.outputs.config
}
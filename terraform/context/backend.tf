variable "bucket" {
  description = "MinIO bucket"
  type = string
}

variable "endpoints" {
  description = "MinIO endpoint"
  type = object({
      s3 = string
  })
}

variable "access_key" {
  description = "MinIO access key"
  type = string
}

variable "secret_key" {
  description = "MinIO access key"
  type = string
}

variable "region" {
  description = "MinIO access key"
  type = string
  default = "us-east-1"
}

variable "skip_credentials_validation" {
  description = "MinIO access key"
  type = bool
  default = true
}

variable "skip_metadata_api_check" {
  description = "MinIO access key"
  type = bool
  default = true
}

variable "skip_region_validation" {
  description = "MinIO access key"
  type = bool
  default = true
}

variable "skip_requesting_account_id" {
  description = "MinIO access key"
  type = bool
  default = true
}

variable "use_path_style" {
  description = "MinIO access key"
  type = bool
  default = true
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  skip_credentials_validation = var.skip_credentials_validation
  skip_metadata_api_check = var.skip_metadata_api_check
  skip_region_validation = var.skip_region_validation
  skip_requesting_account_id = var.skip_requesting_account_id
  
  endpoints {
    s3 = var.endpoints.s3
  }
}

data "terraform_remote_state" "config" {
  backend = "s3"

  config = {
    bucket = var.bucket
    key = "config.tfstate"
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
    endpoints = var.endpoints
    skip_credentials_validation = var.skip_credentials_validation
    skip_metadata_api_check = var.skip_metadata_api_check
    skip_region_validation = var.skip_region_validation
    skip_requesting_account_id  = var.skip_requesting_account_id
    use_path_style = var.use_path_style
  }
}

locals {
  config = data.terraform_remote_state.config.outputs.config
  sensitive = data.terraform_remote_state.config.outputs.sensitive
}
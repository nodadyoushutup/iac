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
}

variable "skip_credentials_validation" {
    description = "MinIO access key"
    type = bool
}

variable "skip_metadata_api_check" {
    description = "MinIO access key"
    type = bool
}

variable "skip_region_validation" {
    description = "MinIO access key"
    type = bool
}

variable "use_path_style" {
    description = "MinIO access key"
    type = bool
}

variable "skip_requesting_account_id" {
    description = "MinIO access key"
    type = bool
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

data "aws_s3_object" "config" {
    bucket = var.bucket
    key = "config.json"
}

locals {
    config = jsondecode(data.aws_s3_object.config.body)
}

output "config" {
    value = local.config
}
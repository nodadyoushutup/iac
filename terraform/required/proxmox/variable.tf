variable "ssh_private_key" {
    type = string
    default = null
}

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

locals {
  config = data.terraform_remote_state.config.outputs.config
}
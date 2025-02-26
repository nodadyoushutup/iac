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
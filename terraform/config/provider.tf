terraform {
    backend "s3" {
        key = "config.tfstate"
    }
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

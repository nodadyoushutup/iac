# terraform/job/jenkins/provider.tf

terraform {
    required_providers {
        jenkins = {
            source  = "taiidani/jenkins"
            version = "0.10.2"
        }
    }

    backend "s3" {
        key = "jenkins.tfstate"
    }
}

provider "jenkins" {
    server_url = local.config.terraform.jenkins.server_url
    username = "admin"
    password = "admin"
}
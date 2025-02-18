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
    server_url = jsondecode(data.aws_s3_object.config.body).machine.clickops.initialization.ip_config.ipv4.address
}
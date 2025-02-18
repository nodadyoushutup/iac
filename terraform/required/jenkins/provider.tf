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

locals {
    # server_url = jsondecode(data.aws_s3_object.config.body).machine.clickops.initialization.ip_config.ipv4.address
    config = jsondecode(data.aws_s3_object.config.body)
}

output "local" {
    value = local.config
}

# provider "jenkins" {
#     server_url = local.server_url
# }
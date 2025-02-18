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

output "config" {
    value = "http://${local.config.machine.clickops.cicd.initialization.ip_config.ipv4.address}:8080"
}

# provider "jenkins" {
#     server_url = "http://${local.config.machine.clickops.cicd.initialization.ip_config.ipv4.address}:8080"
# }
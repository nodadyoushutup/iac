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
    server_url = "http://192.168.0.212:8080/"
}
terraform {
    required_providers {
        docker = {
            source  = "taiidani/jenkins"
            version = "0.10.2"
        }
    }

    backend "s3" {
        key = "dozzle.tfstate"
    }
}

provider "jenkins" {
  server_url = "http://192.168.1.101:8080/"
}
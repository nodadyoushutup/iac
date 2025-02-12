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
  server_url = "http://192.168.0.212:8080/"
}
data "jenkins_job" "jenkins" {
  name        = "job-name"
}
output "example" {
  value = data.jenkins_job.example.template
}
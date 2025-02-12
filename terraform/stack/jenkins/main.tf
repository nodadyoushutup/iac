data "jenkins_job" "proxmox2" {
  name = "proxmox"
}

output "proxmox2" {
  value = data.jenkins_job.proxmox2.template
}

locals {
  template = {
    pipeline = {
      proxmox = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/proxmox"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
    }
  }
}

resource "jenkins_job" "proxmox" {
  name = "proxmox"
  template = local.template.pipeline.proxmox
}
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
          subdir = "terraform/stack/proxmox"
          branch = "main"
        }
      )
    }
  }
}

resource "jenkins_job" "proxmox" {
  name = "proxmox"
  template = local.template.pipeline.proxmox
}
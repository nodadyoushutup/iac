data "jenkins_job" "proxmox2" {
  name = "proxmox"
}

output "proxmox2" {
  value = data.jenkins_job.proxmox2.template
}

resource "jenkins_job" "example" {
  name = "example"
  template = templatefile(
    "${path.module}/job.xml", 
    {
      description = "An example job created from Terraform"
    }
  )
}
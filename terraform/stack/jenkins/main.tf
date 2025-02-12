data "jenkins_job" "proxmox2" {
  name = "proxmox"
}

output "proxmox2" {
  value = data.jenkins_job.proxmox.template
}
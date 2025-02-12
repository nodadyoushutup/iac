data "jenkins_job" "proxmox" {
  name = "proxmox"
}

output "proxmox" {
  value = data.jenkins_job.proxmox.template
}
resource "jenkins_job" "proxmox" {
  name = "proxmox"
  template = local.template.pipeline.proxmox
}
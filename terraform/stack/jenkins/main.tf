resource "jenkins_job" "cadvisor" {
  name = "cadvisor"
  template = local.template.pipeline.cadvisor
}

resource "jenkins_job" "dozzle" {
  name = "dozzle"
  template = local.template.pipeline.dozzle
}

resource "jenkins_job" "grafana" {
  name = "grafana"
  template = local.template.pipeline.grafana
}

resource "jenkins_job" "prometheus" {
  name = "prometheus"
  template = local.template.pipeline.prometheus
}

resource "jenkins_job" "proxmox" {
  name = "proxmox"
  template = local.template.pipeline.proxmox
}
locals {
  jenkins_config_pipeline = trimspace(file("${path.root}/../../pipeline/jenkins.jenkins"))
  dozzle_pipeline         = trimspace(file("${path.root}/../../pipeline/dozzle.jenkins"))
  node_exporter_pipeline  = trimspace(file("${path.root}/../../pipeline/node_exporter.jenkins"))
  prometheus_pipeline     = trimspace(file("${path.root}/../../pipeline/prometheus.jenkins"))
  grafana_pipeline        = trimspace(file("${path.root}/../../pipeline/grafana.jenkins"))
}

resource "jenkins_folder" "folder_jenkins" {
  name = "jenkins"
}

resource "jenkins_job" "jenkins_config" {
  name   = "config"
  folder = jenkins_folder.folder_jenkins.id

  template = templatefile("${path.module}/job/jenkins.xml.tmpl", {
    description = "Jenkins configuration"
    pipeline    = local.jenkins_config_pipeline
  })
}

resource "jenkins_job" "dozzle" {
  name = "dozzle"

  template = templatefile("${path.module}/job/dozzle.xml.tmpl", {
    description = "Dozzle configuration"
    pipeline    = local.dozzle_pipeline
  })
}

resource "jenkins_job" "node_exporter" {
  name = "node_exporter"

  template = templatefile("${path.module}/job/node_exporter.xml.tmpl", {
    description = "Node Exporter configuration"
    pipeline    = local.node_exporter_pipeline
  })
}

resource "jenkins_job" "prometheus" {
  name = "prometheus"

  template = templatefile("${path.module}/job/prometheus.xml.tmpl", {
    description = "Prometheus configuration"
    pipeline    = local.prometheus_pipeline
  })
}

resource "jenkins_job" "grafana" {
  name = "grafana"

  template = templatefile("${path.module}/job/grafana.xml.tmpl", {
    description = "Grafana application and configuration pipeline"
    pipeline    = local.grafana_pipeline
  })
}

resource "jenkins_folder" "folder_jenkins" {
  name = "jenkins"
}

resource "jenkins_job" "jenkins_config" {
  name   = "config"
  folder = jenkins_folder.folder_jenkins.id

  template = templatefile("${path.module}/job/jenkins.xml.tmpl", {
    description = "Jenkins configuration"
  })
}

resource "jenkins_job" "dozzle" {
  name = "dozzle"

  template = templatefile("${path.module}/job/dozzle.xml.tmpl", {
    description = "Dozzle configuration"
  })
}

resource "jenkins_job" "node_exporter" {
  name = "node_exporter"

  template = templatefile("${path.module}/job/node_exporter.xml.tmpl", {
    description = "Node Exporter configuration"
  })
}

resource "jenkins_job" "prometheus" {
  name = "prometheus"

  template = templatefile("${path.module}/job/prometheus.xml.tmpl", {
    description = "Prometheus configuration"
  })
}

resource "jenkins_job" "grafana" {
  name = "grafana"

  template = templatefile("${path.module}/job/grafana.xml.tmpl", {
    description = "Grafana application and configuration pipeline"
  })
}

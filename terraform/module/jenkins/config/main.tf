locals {
  jenkins_config_pipeline = trimspace(file("${path.root}/../../pipeline/jenkins.jenkins"))
  dozzle_pipeline         = trimspace(file("${path.root}/../../pipeline/dozzle.jenkins"))
  node_exporter_pipeline  = trimspace(file("${path.root}/../../pipeline/node_exporter.jenkins"))
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
  name   = "dozzle"

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

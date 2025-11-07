locals {
  jenkins_config_pipeline = trimspace(file("${path.root}/../../pipeline/jenkins.jenkins"))
  dozzle_pipeline = trimspace(file("${path.root}/../../pipeline/dozzle.jenkins"))
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

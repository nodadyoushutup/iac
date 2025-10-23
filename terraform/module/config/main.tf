locals {
  jenkins_config_pipeline = trimspace(file("${path.root}/../pipeline/terraform.jenkins"))
}

resource "jenkins_folder" "folder_jenkins" {
  name = "jenkins"
}

resource "jenkins_job" "jenkins_config" {
  name   = "config"
  folder = jenkins_folder.folder_jenkins.id

  template = templatefile("${path.module}/job/config.xml.tmpl", {
    description = "Jenkins configuration"
    pipeline    = local.jenkins_config_pipeline
  })
}

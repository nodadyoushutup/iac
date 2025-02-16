data "external" "list_directories" {
  program = ["bash", "${path.module}/list_dirs.sh"]
}

locals {
  directories = tolist(data.external.list_directories.result.directories)
}

resource "jenkins_folder" "required" {
  name        = "required"
  description = "Required terraform for base framework operations"
}

resource "jenkins_job" "stack" {
  for_each = toset(local.directories)

  folder   = jenkins_folder.required.id
  name     = each.value
  template = local.template.pipeline.jenkins
}

# resource "jenkins_job" "dozzle" {
#   folder = jenkins_folder.required.id
#   name = "dozzle"
#   template = local.template.pipeline.dozzle
# }

# resource "jenkins_job" "grafana" {
#   folder = jenkins_folder.required.id
#   name = "grafana"
#   template = local.template.pipeline.grafana
# }

# resource "jenkins_job" "prometheus" {
#   folder = jenkins_folder.required.id
#   name = "prometheus"
#   template = local.template.pipeline.prometheus
# }

# resource "jenkins_job" "proxmox" {
#   folder = jenkins_folder.required.id
#   name = "proxmox"
#   template = local.template.pipeline.proxmox
# }

# resource "jenkins_job" "talos" {
#   folder = jenkins_folder.required.id
#   name = "talos"
#   template = local.template.pipeline.talos
# }
data "external" "list_directories" {
  program = ["bash", "${path.module}/script/list_dir_required.sh"]
}

locals {
  directories = toset([
    for dir in keys(data.external.list_directories.result) : dir
    if !can(regex("@", dir)) || !can(regex("jenkins", dir))
  ])
}

resource "jenkins_folder" "required" {
  name = "required"
  description = "Required terraform for base framework operations"
}

resource "jenkins_job" "stack" {
  for_each = toset(local.directories)

  folder = jenkins_folder.required.id
  name = each.value
  template = templatefile(
    "${path.module}/template/job.xml.tpl", 
    {
      subdir = "terraform/required/${each.value}"
      git_repository_branch = var.git.repository.branch
      git_repository_url = var.git.repository.url
    }
  )
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
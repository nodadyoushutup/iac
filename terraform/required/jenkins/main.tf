resource "jenkins_folder" "required" {
  name = "required"
  description = "Required terraform for base framework operations"
}

resource "jenkins_job" "required" {
  for_each = toset(local.directory.required)

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
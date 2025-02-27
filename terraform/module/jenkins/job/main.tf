resource "jenkins_job" "job" {
  name = local.name
  folder = local.folder
  template = templatefile(
    local.path.xml,
    {
      discard_build = local.discard_build
      parameter = local.parameter
      git_repository = local.git_repository
      script_path = local.path.script
    }
  )
}

output "debug" {
  value = local.git_repository
}
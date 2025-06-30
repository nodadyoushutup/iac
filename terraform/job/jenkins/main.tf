# resource "jenkins_folder" "framework" {
#   name = "framework"
#   description = "Required terraform"
# }

# resource "jenkins_folder" "custom" {
#   name = "custom"
#   description = "Custom terraform"
# }

module "job" {
  # depends_on = [
  #   jenkins_folder.framework, 
  #   jenkins_folder.custom
  # ]
  
  for_each = try(local.config.jenkins.job, null) != null ? local.config.jenkins.job : {}
  source = "../../module/jenkins/job"

  config = local.config # Required
  name = try(each.key, null)
  folder = try(each.value.folder, null)
  discard_build = try(each.value.discard_build, null)
  path = try(each.value.path, null)
  parameter = try(each.value.parameter, null)
  git_repository = try(each.value.git_repository, null)
}

output "debug" {
  value = module.job.debug
}
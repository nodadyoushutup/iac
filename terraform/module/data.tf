data "spacelift_context" "config" {
  context_id = "config"
}

data "spacelift_environment_variable" "git_branch" {
  depends_on = [data.spacelift_context.config]
  context_id = data.spacelift_context.config.id
  name = "GIT_BRANCH"
}

data "spacelift_environment_variable" "git_repository" {
  depends_on = [data.spacelift_context.config]
  context_id = data.spacelift_context.config.id
  name = "GIT_REPOSITORY"
}
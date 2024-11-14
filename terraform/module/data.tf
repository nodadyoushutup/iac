data "spacelift_context" "config" {
  context_id = "config"
}

data "spacelift_environment_variable" "GIT_BRANCH" {
  depends_on = [data.spacelift_context.config]
  context_id = data.spacelift_context.config
  name = "GIT_BRANCH"
}

data "spacelift_environment_variable" "GIT_REPOSITORY" {
  depends_on = [data.spacelift_context.config]
  context_id = data.spacelift_context.config
  name = "GIT_REPOSITORY"
}
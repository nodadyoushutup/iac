resource "spacelift_stack_dependency" "module_config" {
  count = var.FLAG_CONFIG >=1 && var.GIT_BRANCH != null && var.GIT_REPOSITORY != null ? 1 : 0
  depends_on = [spacelift_stack.module]
  stack_id = spacelift_stack.module[0].id
  depends_on_stack_id = data.spacelift_stack.config.id
}
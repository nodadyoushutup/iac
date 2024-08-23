resource "spacelift_stack" "stack" {
  ## REQUIRED ##
  name                = var.name
  repository          = var.repository
  branch              = var.branch != null ? var.branch : try(local.config.global.stack.branch, null) != null  ? local.config.global.stack.branch : "main"

  ## UNIQUE ##
  description         = var.description
  labels              = var.labels
  project_root        = var.project_root

  ## OPTIONAL (No Global)
  import_state = try(var.import_state, try(local.config.global.stack.import_state, null))
  import_state_file = try(var.import_state_file, try(local.config.global.stack.import_state_file, null))
  
  ## OPTIONAL ##
  space_id = try(var.space_id, try(local.config.global.stack.space_id, null))
  administrative = try(var.administrative, try(local.config.global.stack.administrative, null))
  autodeploy = try(var.autodeploy, try(local.config.global.stack.autodeploy, null))
  terraform_version = try(var.terraform_version, try(local.config.global.stack.terraform_version, null))
  additional_project_globs = try(var.additional_project_globs, try(local.config.global.stack.additional_project_globs, null))
  autoretry = try(var.autoretry, try(local.config.global.stack.autoretry, null))
  enable_local_preview = try(var.enable_local_preview, try(local.config.global.stack.enable_local_preview, null))
  enable_well_known_secret_masking = try(var.enable_well_known_secret_masking, try(local.config.global.stack.enable_well_known_secret_masking, null))
  github_action_deploy = try(var.github_action_deploy, try(local.config.global.stack.github_action_deploy, null))
  manage_state = try(var.manage_state, try(local.config.global.stack.manage_state, null))
  protect_from_deletion = try(var.protect_from_deletion, try(local.config.global.stack.protect_from_deletion, null))
  terraform_smart_sanitization = try(var.terraform_smart_sanitization, try(local.config.global.stack.terraform_smart_sanitization, null))
  terraform_workflow_tool = try(var.terraform_workflow_tool, try(local.config.global.stack.terraform_workflow_tool, null))

  ## HOOKS ##
  before_apply = try(var.before.apply, try(local.config.global.stack.before.apply, null))
  before_destroy = try(var.before.destroy, try(local.config.global.stack.before.destroy, null))
  before_init = try(var.before.init, try(local.config.global.stack.before.init, null))
  before_perform = try(var.before.perform, try(local.config.global.stack.before.perform, null))
  before_plan = try(var.before.plan, try(local.config.global.stack.before.plan, null))
  after_apply = try(var.after.apply, try(local.config.global.stack.after.apply, null))
  after_destroy = try(var.after.destroy, try(local.config.global.stack.after.destroy, null))
  after_init = try(var.after.init, try(local.config.global.stack.after.init, null))
  after_perform = try(var.after.perform, try(local.config.global.stack.after.perform, null))
  after_plan = try(var.after.plan, try(local.config.global.stack.after.plan, null))
  after_run = try(var.after.run, try(local.config.global.stack.after.run, null))
  
  dynamic "github_enterprise" {
    for_each = var.github_enterprise != null && var.github_enterprise != {} ? [var.github_enterprise] : []
    content {
      namespace = github_enterprise.value.namespace
    }
  }

  dynamic "ansible" {
    for_each = (
      var.ansible != null && var.ansible != {} && (var.terraform_version == null || var.terraform_version == "")
    ) ? [var.ansible] : []
    content {
      playbook = ansible.value.playbook
    }
  }
}

resource "spacelift_context_attachment" "config" {
  context_id = "config"
  stack_id   = var.name
  priority   = var.context_priority
  depends_on = [spacelift_stack.stack]
}

resource "spacelift_stack" "stack" {
  ## REQUIRED ##
  name                = var.name
  repository          = var.repository != null ? var.repository : try(local.config.global.stack.repository, null) != null  ? local.config.global.stack.repository : "iac"
  branch              = var.branch != null ? var.branch : try(local.config.global.stack.branch, null) != null  ? local.config.global.stack.branch : "main"

  ## UNIQUE ##
  description         = var.description
  labels              = var.labels
  project_root        = var.project_root

  ## OPTIONAL (No Global)
  import_state = try(var.import_state, try(local.config.global.stack.import_state, null))
  import_state_file = try(var.import_state_file, try(local.config.global.stack.import_state_file, null))
  
  ## OPTIONAL ##
  space_id = try(var.space_id, try(try(local.stack.space_id, local.config.stack.space_id), null))
  administrative = try(var.administrative, try(try(local.stack.administrative, local.config.stack.administrative), null))
  autodeploy = try(var.autodeploy, try(try(local.stack.autodeploy, local.config.stack.autodeploy), null))
  terraform_version = try(var.terraform_version, try(try(local.stack.terraform_version, local.config.stack.terraform_version), null))
  additional_project_globs = try(var.additional_project_globs, try(try(local.stack.additional_project_globs, local.config.stack.additional_project_globs), null))
  autoretry = try(var.autoretry, try(try(local.stack.autoretry, local.config.stack.autoretry), null))
  enable_local_preview = try(var.enable_local_preview, try(try(local.stack.enable_local_preview, local.config.stack.enable_local_preview), null))
  enable_well_known_secret_masking = try(var.enable_well_known_secret_masking, try(try(local.stack.enable_well_known_secret_masking, local.config.stack.enable_well_known_secret_masking), null))
  github_action_deploy = try(var.github_action_deploy, try(try(local.stack.github_action_deploy, local.config.stack.github_action_deploy), null))
  manage_state = try(var.manage_state, try(try(local.stack.manage_state, local.config.stack.manage_state), null))
  protect_from_deletion = try(var.protect_from_deletion, try(try(local.stack.protect_from_deletion, local.config.stack.protect_from_deletion), null))
  terraform_smart_sanitization = try(var.terraform_smart_sanitization, try(try(local.stack.terraform_smart_sanitization, local.config.stack.terraform_smart_sanitization), null))
  terraform_workflow_tool = try(var.terraform_workflow_tool, try(try(local.stack.terraform_workflow_tool, local.config.stack.terraform_workflow_tool), null))

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
    # for_each = try(var.github_enterprise, null) != null ? [var.github_enterprise] : []
    for_each = try(var.github_enterprise, null) != null ? [1] : []
    content {
      namespace = try(var.github_enterprise, try(local.config.global.stack.github_enterprise, null))
    }
  }

  # dynamic "ansible" {
  #   for_each = (
  #     var.ansible != null && var.ansible != {} && (var.terraform_version == null || var.terraform_version == "")
  #   ) ? [var.ansible] : []
  #   content {
  #     playbook = try(ansible.value.playbook, null)
  #   }
  # }
}

resource "spacelift_context_attachment" "config" {
  context_id = "config"
  stack_id   = var.name
  priority   = var.context_priority
  depends_on = [spacelift_stack.stack]
}

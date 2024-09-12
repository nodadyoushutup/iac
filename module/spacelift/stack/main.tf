

resource "spacelift_stack" "stack" {
  ## REQUIRED ##
  name = var.name

  ## UNIQUE ##
  description = try(
    coalesce(
      try(var.description, null), 
      try(local.stack.description, null), 
      try(local.config.global.stack.description, null)
    ), 
    null
  )
  labels = try(
    concat(
      try(var.labels, []),
      try(local.stack.labels, []),
      try(local.config.global.stack.labels, [])
    ),
    []
  )
  project_root= try(coalesce(try(var.project_root, null), try(local.stack.project_root, null), try(local.config.global.stack.project_root, null)), null)

  ## OPTIONAL (NO GLOBAL)
  import_state = var.import_state
  import_state_file = var.import_state_file
  
  ## OPTIONAL ##
  repository= var.repository
  branch = var.branch
  space_id = var.space_id
  administrative = var.administrative
  autodeploy = var.autodeploy
  terraform_version = var.terraform_version
  additional_project_globs = var.additional_project_globs
  autoretry = var.autoretry
  enable_local_preview = var.enable_local_preview
  enable_well_known_secret_masking = var.enable_well_known_secret_masking
  github_action_deploy = var.github_action_deploy
  manage_state = var.manage_state
  protect_from_deletion = var.protect_from_deletion
  terraform_smart_sanitization = var.terraform_smart_sanitization
  terraform_workflow_tool = var.terraform_workflow_tool

  ## HOOK ##
  before_apply = var.before.apply
  before_destroy = var.before.destroy
  before_init = var.before.init
  before_perform = var.before.perform
  before_plan = var.before.plan
  after_apply = var.after.apply
  after_destroy = var.after.destroy
  after_init = var.after.init
  after_perform = var.after.perform
  after_plan = var.after.plan
  after_run = var.after.run
  
  ## OBJECT ##
  # dynamic "github_enterprise" {
  #   for_each = try(var.github_enterprise, try(try(local.stack.github_enterprise, local.config.stack.github_enterprise), null)) != null ? [1] : []
  #   content {
  #     namespace = try(var.github_enterprise, try(try(local.stack.github_enterprise, local.config.stack.github_enterprise), null))
  #   }
  # }

  # github_enterprise {
  #   namespace = null
  # }

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

resource "spacelift_stack" "stack" {
  ## REQUIRED ##
  name = var.name

  ## OPTIONAL (FORCE DEFAULTS)
  repository = try(
    coalesce(
      try(var.repository, null), 
      try(local.stack.repository, null), 
      try(local.config.global.stack.repository, null)
    ),
    "iac"
  )
  branch = try(
    coalesce(
      try(var.branch, null), 
      try(local.stack.branch, null), 
      try(local.config.global.stack.branch, null)
    ),
    "main"
  )
  terraform_version = try(
    coalesce(
      try(var.terraform_version, null), 
      try(local.stack.terraform_version, null), 
      try(local.config.global.stack.terraform_version, null)
    ),
    "1.5.7"
  )
  
  ## OPTIONAL ##
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
  project_root = try(
    coalesce(
      try(var.project_root, null), 
      try(local.stack.project_root, null), 
      try(local.config.global.stack.project_root, null)
    ),
    null
  )
  import_state = try(
    coalesce(
      try(var.import_state, null), 
      try(local.stack.import_state, null), 
      try(local.config.global.stack.import_state, null)
    ),
    null
  )
  import_state_file = try(
    coalesce(
      try(var.import_state_file, null), 
      try(local.stack.import_state_file, null), 
      try(local.config.global.stack.import_state_file, null)
    ),
    null
  )
  space_id = try(
    coalesce(
      try(var.space_id, null), 
      try(local.stack.space_id, null), 
      try(local.config.global.stack.space_id, null)
    ),
    null
  )
  administrative = try(
    coalesce(
      try(var.administrative, null), 
      try(local.stack.administrative, null), 
      try(local.config.global.stack.administrative, null)
    ),
    null
  )
  autodeploy = try(
    coalesce(
      try(var.autodeploy, null), 
      try(local.stack.autodeploy, null), 
      try(local.config.global.stack.autodeploy, null)
    ),
    null
  )
  additional_project_globs = try(
    coalesce(
      try(var.additional_project_globs, null), 
      try(local.stack.additional_project_globs, null), 
      try(local.config.global.stack.additional_project_globs, null)
    ),
    null
  )
  autoretry = try(
    coalesce(
      try(var.autoretry, null), 
      try(local.stack.autoretry, null), 
      try(local.config.global.stack.autoretry, null)
    ),
    null
  )
  enable_local_preview = try(
    coalesce(
      try(var.enable_local_preview, null), 
      try(local.stack.enable_local_preview, null), 
      try(local.config.global.stack.enable_local_preview, null)
    ),
    null
  )
  enable_well_known_secret_masking = try(
    coalesce(
      try(var.enable_well_known_secret_masking, null), 
      try(local.stack.enable_well_known_secret_masking, null), 
      try(local.config.global.stack.enable_well_known_secret_masking, null)
    ),
    null
  )
  github_action_deploy = try(
    coalesce(
      try(var.github_action_deploy, null), 
      try(local.stack.github_action_deploy, null), 
      try(local.config.global.stack.github_action_deploy, null)
    ),
    null
  )
  manage_state = try(
    coalesce(
      try(var.manage_state, null), 
      try(local.stack.manage_state, null), 
      try(local.config.global.stack.manage_state, null)
    ),
    null
  )
  protect_from_deletion = try(
    coalesce(
      try(var.protect_from_deletion, null), 
      try(local.stack.protect_from_deletion, null), 
      try(local.config.global.stack.protect_from_deletion, null)
    ),
    null
  )
  terraform_smart_sanitization = try(
    coalesce(
      try(var.terraform_smart_sanitization, null), 
      try(local.stack.terraform_smart_sanitization, null), 
      try(local.config.global.stack.terraform_smart_sanitization, null)
    ),
    null
  )
  terraform_workflow_tool = try(
    coalesce(
      try(var.terraform_workflow_tool, null), 
      try(local.stack.terraform_workflow_tool, null), 
      try(local.config.global.stack.terraform_workflow_tool, null)
    ),
    null
  )

  ## HOOK ##
  # before_init = try(
  #   concat(
  #     try(var.before.init, []),
  #     try(local.stack.before.init, []),
  #     try(local.config.global.stack.before.init, [])
  #   ),
  #   []
  # )
  before_init = try(
    coalesce(
      try(var.before.plan, null), 
      try(local.stack.before.plan, null), 
      try(local.config.global.stack.before.plan, null)
    ),
    null
  )
  before_plan = try(
    coalesce(
      try(var.before.plan, null), 
      try(local.stack.before.plan, null), 
      try(local.config.global.stack.before.plan, null)
    ),
    null
  )
  before_apply = try(
    coalesce(
      try(var.before.apply, null), 
      try(local.stack.before.apply, null), 
      try(local.config.global.stack.before.apply, null)
    ),
    null
  )
  before_destroy = try(
    coalesce(
      try(var.before.destroy, null), 
      try(local.stack.before.destroy, null), 
      try(local.config.global.stack.before.destroy, null)
    ),
    null
  )
  before_perform = try(
    coalesce(
      try(var.before.perform, null), 
      try(local.stack.before.perform, null), 
      try(local.config.global.stack.before.perform, null)
    ),
    null
  )
  after_init = var.after.init
  after_plan = var.after.plan
  after_apply = var.after.apply
  after_destroy = var.after.destroy
  after_perform = var.after.perform
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

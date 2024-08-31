# INFRA
# TODO: Fine the best way to organize this code. It's both repetitive, and hard to read with so many brackets
# and levels of complexity when trying ti phjysically read it. Figure out whats going here. 
#  It looks like  what wanted to be here is more work on the Module Param->User Config->Global config-> Worst case secnario if all else fails
module "infra" {
  source  = "spacelift.io/nodadyoushutup/stack/spacelift"
  count = try(contains(local.config.component, var.component), null) ? 1 : 0

  # REQUIRED
  name = try(local.stack.infra.name, "${var.component}_infra")
  repository = try(
    var.repository, try(
      try(
          local.stack.infra.repository, 
          local.config.global.stack.repository
        ), 
      null
    ), 
    null
  )
  branch = try(
    try(
      local.stack.infra.branch, 
      local.config.global.stack.branch
    ), 
    null
  )

  # UNIQUE
  description = try(
    try(
        local.stack.infra.description, 
        local.config.global.stack.description
    ), 
    "${var.component} infrastructure"
  )
  project_root = try(
    try(
      local.stack.infra.project_root, 
      local.config.global.stack.project_root
    ), 
    "${var.component}/infra"
  )
  labels = try(
    try(
      concat(local.stack.infra.labels, ["infra", var.component]), 
      concat(local.config.global.stack.labels, ["infra", var.component])
    ),
    ["infra", var.component]
  )

  # OPTIONAL (No Global)
  import_state = try(local.stack.infra.import_state, null)
  import_state_file = try(local.stack.infra.import_state_file, null)

  # OPTIONAL
  space_id = try(
    try(
      local.stack.infra.space_id, 
      local.config.global.stack.space_id
    ), 
    null
  )
  administrative = try(
    try(
      local.stack.infra.administrative, 
      local.config.global.stack.administrative
    ), 
    null
  )
  autodeploy = try(
    try(
      local.stack.infra.autodeploy, 
      local.config.global.stack.autodeploy
    ), 
    null
  )
  terraform_version = try(
    try(
      local.stack.infra.terraform_version, 
      local.config.global.stack.terraform_version
    ), 
    null
  )
  context_priority = try(
    try(
      local.stack.infra.context_priority, 
      local.config.global.stack.context_priority
    ), 
    null
  )
  github_enterprise = try(
    var.github_enterprise, try(
        try(
            local.stack.infra.github_enterprise, 
            local.config.global.stack.github_enterprise
          ), 
        null
      ), 
    null
  )
  additional_project_globs = try(
    try(
      local.stack.infra.additional_project_globs, 
      local.config.global.stack.additional_project_globs
    ), 
    null
  )
  autoretry = try(
    try(
      local.stack.infra.autoretry, 
      local.config.global.stack.autoretry
    ), 
    null
  )
  enable_local_preview = try(
    try(
      local.stack.infra.enable_local_preview, 
      local.config.global.stack.enable_local_preview
    ), 
    null
  )
  enable_well_known_secret_masking = try(
    try(
      local.stack.infra.enable_well_known_secret_masking, 
      local.config.global.stack.enable_well_known_secret_masking
    ), 
    null
  )
  github_action_deploy = try(
    try(
      local.stack.infra.github_action_deploy, 
      local.config.global.stack.github_action_deploy
    ), 
    null
  )
  manage_state = try(
    try(
      local.stack.infra.manage_state, 
      local.config.global.stack.manage_state
    ), 
    null
  )
  protect_from_deletion = try(
    try(
      local.stack.infra.protect_from_deletion, 
      local.config.global.stack.protect_from_deletion
    ), 
    null
  )
  terraform_smart_sanitization = try(
    try(
      local.stack.infra.terraform_smart_sanitization, 
      local.config.global.stack.terraform_smart_sanitization
    ), 
    null
  )
  terraform_workflow_tool = try(
    try(
      local.stack.infra.terraform_workflow_tool, 
      local.config.global.stack.terraform_workflow_tool
    ), 
    null
  )
  before = {
    apply = try(
      try(
        local.stack.infra.before.apply, 
        local.config.global.stack.before.apply
      ), 
      null
    )
    destroy = try(
      try(
        local.stack.infra.before.destroy, 
        local.config.global.stack.before.destroy
      ), 
      null
    )
    init = try(
      try(
        local.stack.infra.before.init, 
        local.config.global.stack.before.init
      ), 
      null
    )
    perform = try(
      try(
        local.stack.infra.before.perform, 
        local.config.global.stack.before.perform
      ), 
      null
    )
  }
  after = {
    apply = try(
      try(
        local.stack.infra.after.apply, 
        local.config.global.stack.after.apply
      ), 
      null
    )
    destroy = try(
      try(
        local.stack.infra.after.destroy, 
        local.config.global.stack.after.destroy
      ), 
      null
    )
    init = try(
      try(
        local.stack.infra.after.init, 
        local.config.global.stack.after.init
      ), 
      null
    )
    perform = try(
      try(
        local.stack.infra.after.perform, 
        local.config.global.stack.after.perform
      ), 
      null
    )
  }
}
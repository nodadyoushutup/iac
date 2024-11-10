resource "spacelift_stack" "stack" {
    # REQUIRED
    branch         = var.branch
    name           = var.name
    repository     = var.repository

    # OPTIONAL
    additional_project_globs           = var.additional_project_globs
    administrative                     = var.administrative
    after_apply                        = var.after_apply
    after_destroy                      = var.after_destroy
    after_init                         = var.after_init
    after_perform                      = var.after_perform
    after_plan                         = var.after_plan
    after_run                          = var.after_run
    autodeploy                         = var.autodeploy
    autoretry                          = var.autoretry
    before_apply                       = var.before_apply
    before_destroy                     = var.before_destroy
    before_init                        = var.before_init
    before_perform                     = var.before_perform
    before_plan                        = var.before_plan
    description                        = var.description
    enable_local_preview               = var.enable_local_preview
    enable_well_known_secret_masking   = var.enable_well_known_secret_masking
    github_action_deploy               = var.github_action_deploy
    import_state                       = var.import_state
    import_state_file                  = var.import_state_file
    labels                             = var.labels
    manage_state                       = var.manage_state
    project_root                       = var.project_root
    protect_from_deletion              = var.protect_from_deletion
    runner_image                       = var.runner_image
    slug                               = var.slug
    space_id                           = var.space_id
    terraform_external_state_access    = var.terraform_external_state_access
    terraform_smart_sanitization       = var.terraform_smart_sanitization
    terraform_version                  = var.terraform_version != null && var.ansible == null ? var.terraform_version : null
    terraform_workflow_tool            = var.terraform_workflow_tool
    terraform_workspace                = var.terraform_workspace
    worker_pool_id                     = var.worker_pool_id

    dynamic "ansible" {
        for_each = (var.ansible != null && var.terraform_version == null) ? [var.ansible] : []
        content {
            playbook = ansible.value.playbook
        }
    }

    dynamic "raw_git" {
        for_each = var.raw_git != null ? [var.raw_git] : []
        content {
            namespace = raw_git.value.namespace
            url       = raw_git.value.url
        }
    }
}

resource "spacelift_context_attachment" "config_context_attachment" {
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "terraform_context_attachment" {
    context_id = data.spacelift_context.terraform.id
    stack_id   = spacelift_stack.stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "ansible_context_attachment" {
    count = var.ansible != null && var.terraform_version == null ? 1 : 0
    context_id = data.spacelift_context.ansible.id
    stack_id   = spacelift_stack.stack.id
    priority   = 0
}
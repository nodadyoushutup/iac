resource "spacelift_context_attachment" "config_config" {
    depends_on = [spacelift_context.config]
    context_id = spacelift_context.config.id
    stack_id   = data.spacelift_stack.config.id
    priority   = 0
}

resource "spacelift_context_attachment" "pyvenv_config" {
    depends_on = [spacelift_context.config]
    context_id = spacelift_context.pyvenv.id
    stack_id   = data.spacelift_stack.config.id
    priority   = 0
}

resource "spacelift_context_attachment" "spacectl_module" {
    count = var.FLAG_CONFIG >=1 && var.GIT_BRANCH != null && var.GIT_REPOSITORY != null ? 1 : 0
    depends_on = [spacelift_context.module]
    context_id = spacelift_context.spacectl.id
    stack_id   = spacelift_stack.module.id
    priority   = 0
}


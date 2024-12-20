resource "spacelift_context_attachment" "config_spacelift" {
    depends_on = [
        spacelift_context.config,
        data.spacelift_stack.spacelift    
    ]
    context_id = spacelift_context.config.id
    stack_id   = data.spacelift_stack.spacelift.id
    priority   = 0
}

resource "spacelift_context_attachment" "config_proxmox" {
    depends_on = [
        spacelift_context.config,
        spacelift_stack.proxmox
    ]
    context_id = spacelift_context.config.id
    stack_id   = spacelift_stack.proxmox.id
    priority   = 0
}

resource "spacelift_context_attachment" "config_development" {
    depends_on = [
        spacelift_context.config,
        spacelift_stack.development
    ]
    context_id = spacelift_context.config.id
    stack_id   = spacelift_stack.development.id
    priority   = 0
}
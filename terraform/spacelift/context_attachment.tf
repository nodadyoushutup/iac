resource "spacelift_context_attachment" "config_spacelift" {
    depends_on = [spacelift_context.config]
    context_id = spacelift_context.config.id
    stack_id   = data.spacelift_stack.spacelift.id
    priority   = 0
}

resource "spacelift_context_attachment" "config_proxmox" {
    count = var.FLAG_VALID_CONFIG >=1 ? 1 : 0
    depends_on = [
        spacelift_context.config,
        spacelift_stack.proxmox
    ]
    context_id = spacelift_context.config.id
    stack_id   = spacelift_stack.proxmox[0].id
    priority   = 0
}
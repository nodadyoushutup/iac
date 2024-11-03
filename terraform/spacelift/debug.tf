resource "spacelift_stack" "debug_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_infra_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker initialization"
    name = "debug"
    project_root = "ansible/stack/debug"
    repository = "iac"
    labels = ["ansible", "init", "docker", "administrative", "p1", "p1b"]
    ansible {
        playbook = "main.yaml"
    }
}

resource "spacelift_context_attachment" "debug_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.debug_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.debug_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "debug_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.debug_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.debug_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "debug_ansible_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.debug_stack, 
        spacelift_context.ansible_context,
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.debug_stack[count.index].id
    priority   = 0
}
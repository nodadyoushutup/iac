### CONTEXT ###
resource "spacelift_context" "terraform_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Infrastructure as Code  Configuration"
    name        = "terraform"
}

resource "spacelift_context" "ansible_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Ansible configuration"
    name        = "ansible"
    before_init = [
        "chmod 600 ${local.config.spacelift.path.private_key}"
    ]
}

resource "spacelift_context_attachment" "spacelift_terraform_context_attachment" {
    depends_on = [spacelift_context.terraform_context]
    context_id = spacelift_context.terraform_context.id
    stack_id   = data.spacelift_stack.spacelift.id
    priority   = 0
}


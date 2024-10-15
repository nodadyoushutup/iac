### ANSIBLE ###
resource "spacelift_context" "ansible_hooks" {
    description = "Ansible hooks"
    name        = "ansible_hooks"
    before_init = [
        "/mnt/workspace/source/ansible/install.sh",
        "source venv/bin/activate"
    ]
}

### DOCKER ###
resource "spacelift_stack" "docker_stack" {
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker applications"
    name = "docker"
    project_root = "terraform/docker"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["ansible", "docker", "administrative", "p1"]
}

resource "spacelift_context_attachment" "docker_context_attachment_config" {
    depends_on = [spacelift_stack.docker_stack]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.docker_stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_context_attachment_ansible" {
    depends_on = [spacelift_stack.docker_stack]
    context_id = spacelift_context.ansible.id
    stack_id   = spacelift_stack.docker_stack.id
    priority   = 0
}

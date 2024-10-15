### ANSIBLE ###
# resource "spacelift_context" "ansible_hook" {
#     description = "Ansible hook"
#     name        = "ansible_hook"
#     before_init = [
#         "/mnt/workspace/source/ansible/install.sh",
#         "source venv/bin/activate"
#     ]
# }

### DOCKER ###
resource "spacelift_stack" "docker_infra_stack" {
    depends_on = [spacelift_context.ansible_hook]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker applications"
    name = "docker_infra"
    project_root = "terraform/docker"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["ansible", "docker", "administrative", "p1"]
}

resource "spacelift_stack" "docker_init_stack" {
    depends_on = [spacelift_context.ansible_hook]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker applications"
    name = "docker_init"
    project_root = "ansible"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["ansible", "docker", "administrative", "p1"]
    ansible {
        playbook = "docker_init.yaml"
    }
}

resource "spacelift_context_attachment" "docker_context_attachment_config" {
    depends_on = [spacelift_stack.docker_infra_stack]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.docker_infra_stack.id
    priority   = 0
}

# resource "spacelift_context_attachment" "docker_context_attachment_ansible_hook" {
#     depends_on = [spacelift_stack.docker_infra_stack]
#     context_id = spacelift_context.ansible_hook.id
#     stack_id   = spacelift_stack.docker_infra_stack.id
#     priority   = 0
# }

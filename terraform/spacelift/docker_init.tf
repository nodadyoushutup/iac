resource "spacelift_stack" "docker_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_infra_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker initialization"
    name = "docker_init"
    project_root = "ansible/playbook"
    repository = "iac"
    labels = ["ansible", "init", "docker", "administrative", "p1", "p1b"]
    # additional_project_globs = [
    #     "role/apt_lock_check",
    #     "role/config_load",
    #     "role/docker_compose",
    #     "role/docker",
    #     "role/gitconfig",
    #     "role/node_exporter",
    #     "role/vm_init",
    #     "role/vm_ping"
    # ]
    ansible {
        playbook = "docker_init.yaml"
    }
}

resource "spacelift_context_attachment" "docker_init_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.docker_init_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.docker_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_init_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.docker_init_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.docker_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_init_ansible_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.docker_init_stack, 
        spacelift_context.ansible_context,
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.docker_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "docker_init_docker_infra_stack_dependency" {
  count = local.env > 0 && local.config.spacelift.dependency_deploy.docker.init ? 1 : 0
  depends_on = [
        spacelift_stack.docker_infra_stack, 
        spacelift_stack.docker_init_stack,
    ]
  stack_id = spacelift_stack.docker_init_stack[count.index].id
  depends_on_stack_id = spacelift_stack.docker_infra_stack[count.index].id
}
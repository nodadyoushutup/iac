resource "spacelift_stack" "docker_infra_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_environment_variable.env_environment_variable,
        spacelift_context.ansible_hook_context
    ]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker applications"
    name = "docker_infra"
    project_root = "terraform/docker"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["terraform", "infra", "docker", "administrative", "p1", "p1a"]
}

resource "spacelift_context_attachment" "docker_infra_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.docker_infra_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id = spacelift_stack.docker_infra_stack[count.index].id
    priority = 0
}

resource "spacelift_stack_dependency" "docker_infra_spacelift_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.docker.infra ? 1 : 0
    depends_on = [
        data.spacelift_stack.spacelift, 
        spacelift_stack.docker_infra_stack,
    ]
    stack_id = spacelift_stack.docker_infra_stack[count.index].id
    depends_on_stack_id = data.spacelift_stack.spacelift.id
}


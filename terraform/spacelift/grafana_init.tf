resource "spacelift_stack" "grafana_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.collector_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Grafana initialization"
    name = "grafana_init"
    project_root = "ansible/stack_grafana_init"
    repository = "iac"
    labels = ["ansible", "init", "grafana", "administrative", "p1", "p1b"]
    # additional_project_globs = [
    #     "role/docker_compose",
    #     "role/config_load",
    #     "role/vm_init",
    #     "role/vm_ping"
    # ]
    ansible {
        playbook = "main.yaml"
    }
}

resource "spacelift_context_attachment" "grafana_init_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_init_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.grafana_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "grafana_init_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_init_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.grafana_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "grafana_init_ansible_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_init_stack, 
        spacelift_context.ansible_context
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.grafana_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "grafana_init_collector_init_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.grafana.init ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_init_stack, 
        spacelift_stack.collector_init_stack,
    ]
    stack_id = spacelift_stack.grafana_init_stack[count.index].id
    depends_on_stack_id = spacelift_stack.collector_init_stack[count.index].id
}
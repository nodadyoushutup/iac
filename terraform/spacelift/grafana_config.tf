resource "spacelift_stack" "grafana_config_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.grafana_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Grafana configuration"
    name = "grafana_config"
    project_root = "terraform/grafana"
    repository = "iac"
    labels = ["ansible", "init", "grafana", "administrative", "p1", "p1b"]
    additional_project_globs = [
        "dashboard/**",
    ]
}

resource "spacelift_context_attachment" "grafana_config_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_config_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.grafana_config_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "grafana_config_grafana_init_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.grafana.config ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_config_stack, 
        spacelift_stack.grafana_init_stack,
    ]
    stack_id = spacelift_stack.grafana_config_stack[count.index].id
    depends_on_stack_id = spacelift_stack.grafana_init_stack[count.index].id
}
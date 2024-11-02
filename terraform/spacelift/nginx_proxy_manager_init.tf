resource "spacelift_stack" "nginx_proxy_manager_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Nginx Proxy Manager initialization"
    name = "nginx_proxy_manager_init"
    project_root = "ansible/stack/nginx_proxy_manager_init"
    repository = "iac"
    labels = ["ansible", "init", "collector", "administrative"]
    ansible {
        playbook = "main.yaml"
    }
}

resource "spacelift_context_attachment" "nginx_proxy_manager_init_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "nginx_proxy_manager_init_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "nginx_proxy_manager_init_ansible_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack, 
        spacelift_context.ansible_context
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "nginx_proxy_manager_init_grafana_config_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.nginx_proxy_manager.init ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack, 
        spacelift_stack.grafana_config_stack,
    ]
    stack_id = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    depends_on_stack_id = spacelift_stack.grafana_config_stack[count.index].id
}
resource "spacelift_stack" "nginx_proxy_manager_config_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.nginx_proxy_manager_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Nginx Proxy Manager configuration"
    name = "nginx_proxy_manager_config"
    project_root = "terraform/nginx_proxy_manager"
    repository = "iac"
    labels = ["ansible", "init", "nginx_proxy_manager", "administrative", "p1", "p1b"]
    additional_project_globs = [
        "dashboard/**",
    ]
}

resource "spacelift_context_attachment" "nginx_proxy_manager_config_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_config_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_config_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "nginx_proxy_manager_config_terraform_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_config_stack,
        spacelift_context.terraform_context
    ]
    context_id = spacelift_context.terraform_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_config_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "nginx_proxy_manager_config_nginx_proxy_manager_init_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.nginx_proxy_manager.config ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_config_stack, 
        spacelift_stack.nginx_proxy_manager_init_stack,
    ]
    stack_id = spacelift_stack.nginx_proxy_manager_config_stack[count.index].id
    depends_on_stack_id = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
}
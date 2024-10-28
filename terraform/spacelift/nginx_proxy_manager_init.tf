resource "spacelift_stack" "nginx_proxy_manager_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Nginx Proxy Manager initialization"
    name = "nginx_proxy_manager_init"
    project_root = "ansible"
    repository = "iac"
    labels = ["ansible", "init", "collector", "administrative"]
    additional_project_globs = [
        "role/docker_compose",
        "role/config_load",
        "role/nginx_proxy_manager_admin",
        "role/nginx_proxy_manager_host",
        "role/vm_init",
        "role/vm_ping"
    ]
    ansible {
        playbook = "nginx_proxy_manager_init.yaml"
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

resource "spacelift_context_attachment" "nginx_proxy_manager_init_ansible_context_attachment" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.nginx_proxy_manager.init ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack, 
        spacelift_context.ansible_context
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack" "nginx_proxy_manager_config_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Nginx Proxy Manager configuration"
    name = "nginx_proxy_manager_config"
    project_root = "ansible/stack/nginx_proxy_manager_config"
    repository = "iac"
    labels = ["ansible", "config", "collector", "administrative"]
    ansible {
        playbook = "main.yaml"
    }
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

resource "spacelift_context_attachment" "nginx_proxy_manager_config_ansible_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_config_stack, 
        spacelift_context.ansible_context
    ]
    context_id = spacelift_context.ansible_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_config_stack[count.index].id
    priority   = 0
}

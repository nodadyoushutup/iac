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
    # additional_project_globs = [
    #     "/mnt/workspace/source/ansible/role/docker_compose",
    #     "/mnt/workspace/source/ansible/role/config_load",
    #     "/mnt/workspace/source/ansible/role/nginx_proxy_manager_admin",
    #     "/mnt/workspace/source/ansible/role/nginx_proxy_manager_host",
    #     "/mnt/workspace/source/ansible/role/vm_init",
    #     "/mnt/workspace/source/ansible/role/vm_ping"
    # ]
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

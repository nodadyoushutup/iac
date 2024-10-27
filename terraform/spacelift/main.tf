# ### CONTEXT ###
resource "spacelift_context" "config_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Infrastructure as Code  Configuration"
    name        = "config"
}

resource "spacelift_context_attachment" "spacelift_config_context_attachment" {
    depends_on = [spacelift_context.config_context]
    context_id = spacelift_context.config_context.id
    stack_id   = data.spacelift_stack.spacelift.id
    priority   = 0
}

resource "spacelift_context" "ansible_hook_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Ansible hook"
    name        = "ansible_hook"
    before_init = [
        "chmod 600 ${local.config.spacelift.path.private_key}"
    ]
}

### MOUNTED FILE ###
resource "spacelift_mounted_file" "config_mounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "config.yaml"
    content = local.base64.config
    write_only = false
}

resource "spacelift_mounted_file" "private_keymounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "id_rsa"
    content = local.base64.private_key
    write_only = true
}

resource "spacelift_mounted_file" "inventory_keymounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "inventory"
    content = local.base64.ansible.inventory
    write_only = false
}

resource "spacelift_mounted_file" "env_keymounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = ".env"
    content = local.base64.docker.env
    write_only = false
}

### ENVIRONMENT VARIABLES ###
resource "spacelift_environment_variable" "tf_log_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "TF_LOG" 
    value       = "debug"
    write_only  = false 
    description = "Terraform log level"
}

resource "spacelift_environment_variable" "config_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "TF_VAR_CONFIG" 
    value       = local.config_path
    write_only  = false 
    description = "Terraform configuration path"
}

resource "spacelift_environment_variable" "ansible_verbosity_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "ANSIBLE_VERBOSITY" 
    value       = 0
    write_only  = false 
    description = "Ansible log level"
}

resource "spacelift_environment_variable" "ansible_private_key_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "ANSIBLE_PRIVATE_KEY_FILE" 
    value       = local.config.spacelift.path.private_key
    write_only  = false 
    description = "Ansible SSH private Key"
}

resource "spacelift_environment_variable" "ansible_config_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "ANSIBLE_CONFIG" 
    value       = local.config.spacelift.path.ansible.config
    write_only  = false 
    description = "Ansible configuration path"
}

resource "spacelift_environment_variable" "ansible_remote_user_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "ANSIBLE_REMOTE_USER" 
    value       = local.config.virtual_machine.username
    write_only  = false 
    description = "Ansible SSH private Key"
}

resource "spacelift_environment_variable" "ansible_inventory_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "ANSIBLE_INVENTORY" 
    value       = local.config.spacelift.path.ansible.inventory
    write_only  = false 
    description = "Ansible inventory path"
}

resource "spacelift_environment_variable" "env_environment_variable" { 
    depends_on = [
        spacelift_context.config_context,
        spacelift_mounted_file.config_mounted_file,
        spacelift_mounted_file.private_keymounted_file,
        spacelift_mounted_file.env_keymounted_file,
        spacelift_mounted_file.private_keymounted_file,
        spacelift_environment_variable.config_environment_variable,
        spacelift_environment_variable.tf_log_environment_variable,
        spacelift_environment_variable.ansible_verbosity_environment_variable,
        spacelift_environment_variable.ansible_private_key_environment_variable,
        spacelift_environment_variable.ansible_config_environment_variable,
        spacelift_environment_variable.ansible_remote_user_environment_variable,
        spacelift_environment_variable.ansible_inventory_environment_variable
    ]
    context_id  = spacelift_context.config_context.id
    name        = "TF_VAR_ENV" 
    value       = data.external.validate_docker_env.result["valid"] == "true" && data.external.validate_gitconfig.result["valid"] == "true" && data.external.validate_ansible_inventory.result["valid"] == "true" && data.external.validate_private_key.result["valid"] == "true"? local.env + 1 : local.env
    write_only  = false 
    description = "Flag for valid environment initialization"
}

### DOCKER ###
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

resource "spacelift_stack" "docker_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_infra_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker initialization"
    name = "docker_init"
    project_root = "ansible"
    repository = "iac"
    labels = ["ansible", "init", "docker", "administrative", "p1", "p1b"]
    additional_project_globs = [
        "role/apt_lock_check",
        "role/config_load",
        "role/docker_compose",
        "role/docker",
        "role/gitconfig",
        "role/node_exporter",
        "role/vm_init",
        "role/vm_ping"
    ]
    ansible {
        playbook = "docker_init.yaml"
    }
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

resource "spacelift_context_attachment" "docker_init_ansible_hook_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.docker_init_stack, 
        spacelift_context.ansible_hook_context,
    ]
    context_id = spacelift_context.ansible_hook_context.id
    stack_id   = spacelift_stack.docker_init_stack[count.index].id
    priority   = 0
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

resource "spacelift_stack_dependency" "docker_init_docker_infra_stack_dependency" {
  count = local.env > 0 && local.config.spacelift.dependency_deploy.docker.init ? 1 : 0
  depends_on = [
        spacelift_stack.docker_infra_stack, 
        spacelift_stack.docker_init_stack,
    ]
  stack_id = spacelift_stack.docker_init_stack[count.index].id
  depends_on_stack_id = spacelift_stack.docker_infra_stack[count.index].id
}

### COLLECTOR ###
resource "spacelift_stack" "collector_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Collector initialization"
    name = "collector_init"
    project_root = "ansible"
    repository = "iac"
    labels = ["ansible", "init", "collector", "administrative", "p1", "p1b"]
    additional_project_globs = [
        "role/docker_compose",
        "role/config_load",
        "role/prometheus",
        "role/vm_init",
        "role/vm_ping"
    ]
    ansible {
        playbook = "collector_init.yaml"
    }
}

resource "spacelift_context_attachment" "collector_init_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.collector_init_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.collector_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "collector_init_ansible_hook_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.collector_init_stack, 
        spacelift_context.ansible_hook_context
    ]
    context_id = spacelift_context.ansible_hook_context.id
    stack_id   = spacelift_stack.collector_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_stack_dependency" "collector_init_docker_init_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.collector.init ? 1 : 0
    depends_on = [
        spacelift_stack.docker_init_stack, 
        spacelift_stack.collector_init_stack,
    ]
    stack_id = spacelift_stack.collector_init_stack[count.index].id
    depends_on_stack_id = spacelift_stack.docker_init_stack[count.index].id
}

### GRAFANA ###
resource "spacelift_stack" "grafana_init_stack" {
    count = local.env > 0 ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Grafana initialization"
    name = "grafana_init"
    project_root = "ansible"
    repository = "iac"
    labels = ["ansible", "init", "grafana", "administrative", "p1", "p1b"]
    additional_project_globs = [
        "role/docker_compose",
        "role/config_load",
        "role/vm_init",
        "role/vm_ping"
    ]
    ansible {
        playbook = "grafana_init.yaml"
    }
}

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

resource "spacelift_context_attachment" "grafana_config_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_config_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.grafana_config_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "grafana_init_ansible_hook_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_init_stack, 
        spacelift_context.ansible_hook_context
    ]
    context_id = spacelift_context.ansible_hook_context.id
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

resource "spacelift_stack_dependency" "grafana_config_grafana_init_stack_dependency" {
    count = local.env > 0 && local.config.spacelift.dependency_deploy.grafana.config ? 1 : 0
    depends_on = [
        spacelift_stack.grafana_config_stack, 
        spacelift_stack.grafana_init_stack,
    ]
    stack_id = spacelift_stack.grafana_config_stack[count.index].id
    depends_on_stack_id = spacelift_stack.grafana_init_stack[count.index].id
}

### NGINX PROXY MANAGER ###
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
        "role/vm_init",
        "role/vm_ping"
    ]
    ansible {
        playbook = "nginx_proxy_manager_init.yaml"
    }
}

resource "spacelift_context_attachment" "nginx_proxymanager_init_config_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack,
        spacelift_context.config_context
    ]
    context_id = spacelift_context.config_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}

resource "spacelift_context_attachment" "nginx_proxy_manager_init_ansible_hook_context_attachment" {
    count = local.env > 0 ? 1 : 0
    depends_on = [
        spacelift_stack.nginx_proxy_manager_init_stack, 
        spacelift_context.ansible_hook_context
    ]
    context_id = spacelift_context.ansible_hook_context.id
    stack_id   = spacelift_stack.nginx_proxy_manager_init_stack[count.index].id
    priority   = 0
}
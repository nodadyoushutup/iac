### ANSIBLE ###
resource "spacelift_context" "ansible_hook_context" {
    description = "Ansible hook"
    name        = "ansible_hook"
    before_init = [
        ".././before_init.sh"
    ]
}

### DOCKER ###
resource "spacelift_stack" "docker_infra_stack" {
    depends_on = [spacelift_context.ansible_hook_context]
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
    depends_on = [spacelift_stack.docker_infra_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker initialization"
    name = "docker_init"
    project_root = "ansible/playbook"
    repository = "iac"
    labels = ["ansible", "init", "docker", "administrative", "p1", "p1b"]
    ansible {
        playbook = "docker_init.yaml"
    }
}

resource "spacelift_context_attachment" "docker_infra_config_context_attachment" {
    depends_on = [spacelift_stack.docker_infra_stack]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.docker_infra_stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_init_config_context_attachment" {
    depends_on = [spacelift_stack.docker_init_stack]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.docker_init_stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_init_ansible_hook_context_attachment" {
    depends_on = [spacelift_stack.docker_init_stack, spacelift_context.ansible_hook]
    context_id = spacelift_context.ansible_hook.id
    stack_id   = spacelift_stack.docker_init_stack.id
    priority   = 0
}

resource "spacelift_stack_dependency" "docker_infra_spacelift_stack_dependency" {
  count = local.config.dependency_deploy.infra ? 1 : 0
  depends_on = [data.spacelift_stack.spacelift, spacelift_stack.docker_infra_stack]
  stack_id            = spacelift_stack.docker_infra_stack.id
  depends_on_stack_id = data.spacelift_stack.spacelift.id
}

resource "spacelift_stack_dependency" "docker_init_docker_infra_stack_dependency" {
  count = local.config.dependency_deploy.init ? 1 : 0
  depends_on = [spacelift_stack.docker_infra_stack, spacelift_stack.docker_init_stack]
  stack_id            = spacelift_stack.docker_init_stack.id
  depends_on_stack_id = spacelift_stack.docker_infra_stack.id
}

### PROMETHEUS ###
resource "spacelift_stack" "prometheus_init_stack" {
    depends_on = [spacelift_stack.docker_init_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "prometheus initialization"
    name = "prometheus_init"
    project_root = "ansible/playbook"
    repository = "iac"
    labels = ["ansible", "init", "prometheus", "administrative", "p1", "p1b"]
    ansible {
        playbook = "prometheus_init.yaml"
    }
}

resource "spacelift_context_attachment" "prometheus_init_config_context_attachment" {
    depends_on = [spacelift_stack.prometheus_init_stack]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.prometheus_init_stack.id
    priority   = 0
}

resource "spacelift_context_attachment" "prometheus_init_ansible_hook_context_attachment" {
    depends_on = [spacelift_stack.prometheus_init_stack, spacelift_context.ansible_hook]
    context_id = spacelift_context.ansible_hook.id
    stack_id   = spacelift_stack.prometheus_init_stack.id
    priority   = 0
}

resource "spacelift_stack_dependency" "prometheus_init_docker_init_stack_dependency" {
    count = local.config.dependency_deploy.init ? 1 : 0
    depends_on = [spacelift_stack.docker_init_stack, spacelift_stack.prometheus_init_stack]
    stack_id            = spacelift_stack.prometheus_init_stack.id
    depends_on_stack_id = spacelift_stack.docker_init_stack.id
}

### TEST ###
resource "spacelift_environment_variable" "test_env_var" {
  context_id  = "config"
  name        = "TEST_ENV_VAR"
  value       = try(var.TEST_ENV_VAR, "/project/spacelift/kubeconfig")
  write_only  = false
  description = "Test environment variable"
}

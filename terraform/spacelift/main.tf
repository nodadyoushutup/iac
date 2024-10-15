### ENVIRONMENT VARIABLE ###
resource "spacelift_environment_variable" "tf_log" {
  context_id  = data.spacelift_context.config.id
  name        = "TF_LOG"
  value       = "debug"
  write_only  = false
  description = "Terraform log level"
}

### ANSIBLE ###
resource "spacelift_context" "ansible2" {
    description = "Ansible hooks"
    name        = "ansible2"
    before_init = [
        "/mnt/workspace/source/ansible/install.sh",
        "source venv/bin/activate"
    ]
}

### DOCKER ###
resource "spacelift_stack" "docker_stack2" {
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Docker applications"
    name = "docker"
    project_root = "terraform/docker"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["ansible", "docker", "administrative", "p1"]
    additional_project_globs = [
        "ansible/docker",
        "ansible/init_vm",
        "ansible/docker_install",
        "ansible/docker_run"
    ]
}

resource "spacelift_context_attachment" "docker_context_attachment_config" {
    depends_on = [spacelift_stack.docker_stack2]
    context_id = data.spacelift_context.config.id
    stack_id   = spacelift_stack.docker_stack2.id
    priority   = 0
}

resource "spacelift_context_attachment" "docker_context_attachment_ansible2" {
    depends_on = [spacelift_stack.docker_stack2]
    context_id = spacelift_context.ansible2.id
    stack_id   = spacelift_stack.docker_stack2.id
    priority   = 0
}

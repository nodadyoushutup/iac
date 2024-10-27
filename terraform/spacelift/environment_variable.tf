### CONFIG ###
resource "spacelift_environment_variable" "config_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "TF_VAR_CONFIG" 
    value       = local.config_path
    write_only  = false 
    description = "IaC configuration path"
}

### TERRAFORM ###
resource "spacelift_environment_variable" "tf_log_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_terraform_context_attachment]
    context_id  = spacelift_context.terraform_context.id
    name        = "TF_LOG" 
    value       = "debug"
    write_only  = false 
    description = "Terraform log level"
}

resource "spacelift_environment_variable" "env_environment_variable" { 
    depends_on = [
        spacelift_context.terraform_context,
        spacelift_mounted_file.config_mounted_file,
        spacelift_mounted_file.private_keymounted_file,
        spacelift_environment_variable.config_environment_variable,
        spacelift_environment_variable.tf_log_environment_variable,
        spacelift_environment_variable.ansible_verbosity_environment_variable,
        spacelift_environment_variable.ansible_private_key_environment_variable,
        spacelift_environment_variable.ansible_remote_user_environment_variable,
    ]
    context_id  = spacelift_context.terraform_context.id
    name        = "TF_VAR_ENV" 
    value       = data.external.validate_private_key.result["valid"] == "true"? local.env + 1 : local.env
    write_only  = false 
    description = "Flag for valid environment initialization"
}

### ANSIBLE ###
resource "spacelift_environment_variable" "ansible_verbosity_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_VERBOSITY" 
    value       = try(local.config.ansible.defaults.verbosity, 0)
    write_only  = false 
    description = "Ansible log level"
}

resource "spacelift_environment_variable" "ansible_private_key_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_PRIVATE_KEY_FILE" 
    value       = try(local.config.spacelift.private_key, "/mnt/workspace/id_rsa")
    write_only  = false 
    description = "Ansible SSH private Key"
}

resource "spacelift_environment_variable" "ansible_remote_user_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_REMOTE_USER" 
    value       = try(local.config.virtual_machine.username, "ubuntu")
    write_only  = false 
    description = "Ansible SSH private Key"
}

resource "spacelift_environment_variable" "ansible_defaults_host_key_checking_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_HOST_KEY_CHECKING" 
    value       = try(local.config.ansible.defaults.host_key_checking, false)
    write_only  = false 
    description = "Ansible host key checking"
}

resource "spacelift_environment_variable" "ansible_defaults_retry_files_enabled_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_RETRY_FILES_ENABLED" 
    value       = try(local.config.ansible.defaults.retry_files_enabled, false)
    write_only  = false 
    description = "Ansible retry files enabled"
}

resource "spacelift_environment_variable" "ansible_defaults_stdout_callback_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_STDOUT_CALLBACK" 
    value       = try(local.config.ansible.defaults.stdout_callback, "yaml")
    write_only  = false 
    description = "Ansible stdout callback"
}

resource "spacelift_environment_variable" "ansible_become_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_BECOME" 
    value       = try(local.config.ansible.privilege_escalation.become, true)
    write_only  = false 
    description = "Ansible become"
}

resource "spacelift_environment_variable" "ansible_become_method_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_BECOME_METHOD" 
    value       = try(local.config.ansible.privilege_escalation.become_method, "sudo")
    write_only  = false 
    description = "Ansible become method"
}

resource "spacelift_environment_variable" "ansible_become_user_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_BECOME_USER" 
    value       = try(local.config.ansible.privilege_escalation.become_user, "root")
    write_only  = false 
    description = "Ansible become user"
}

resource "spacelift_environment_variable" "ansible_become_ask_pass_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_BECOME_ASK_PASS" 
    value       = try(local.config.ansible.privilege_escalation.become_ask_pass, false)
    write_only  = false 
    description = "Ansible become ask pass"
}

resource "spacelift_environment_variable" "ansible_ssh_connection_timeout_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_TIMEOUT" 
    value       = try(local.config.ansible.ssh_connection.timeout, 10)
    write_only  = false 
    description = "Ansible timeout"
}

resource "spacelift_environment_variable" "ansible_ssh_connection_pipelining_environment_variable" { 
    depends_on = [spacelift_context.ansible_context]
    context_id  = spacelift_context.ansible_context.id
    name        = "ANSIBLE_PIPELINING" 
    value       = try(local.config.ansible.ssh_connection.pipelining, true)
    write_only  = false 
    description = "Ansible pipelining"
}



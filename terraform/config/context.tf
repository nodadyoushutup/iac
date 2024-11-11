resource "spacelift_context" "pyvenv" {
    description = "Runner Python virtual environment hooks"
    name = "pyvenv"
    space_id = data.spacelift_space.root.id
    before_init = [
        "python3 -m venv venv",
        "source venv/bin/activate",
        "pip install --upgrade pip && pip install pyyaml paramiko",
    ]
}

resource "spacelift_context" "env_flag" {
    description = "Environment flags"
    name = "env_flag"
    space_id = data.spacelift_space.root.id
}


# resource "spacelift_context" "config" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [ spacelift_context_attachment.env_flag_config ]
#     description = "Configuration"
#     name = "config"
#     space_id = data.spacelift_space.root.id
# }
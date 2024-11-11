resource "spacelift_context" "pyvenv" {
    name = "pyvenv"
    description = "Runner Python virtual environment hooks"
    space_id = data.spacelift_space.root.id
    before_init = [
        "python3 -m venv venv",
        "source venv/bin/activate",
        "pip install --upgrade pip && pip install pyyaml paramiko",
    ]
}

resource "spacelift_context" "env_flag" {
    name = "env_flag"
    description = "Environment flags"
    space_id = data.spacelift_space.root.id
}


resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = data.spacelift_space.root.id
}
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

resource "spacelift_context" "spacectl" {
    name = "spacectl"
    description = "Runner Spacectl CLI"
    space_id = data.spacelift_space.root.id
    after_apply = [
        "python3 ${path.module}/script/after_apply.py"
    ]
}

resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = data.spacelift_space.root.id
    before_init = [
        "chmod 600 ${var.PATH_PRIVATE_KEY}"
    ]
}
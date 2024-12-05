# resource "spacelift_context" "pyvenv" {
#     name = "pyvenv"
#     description = "Runner Python virtual environment hooks"
#     space_id = data.spacelift_space.root.id
#     before_init = [
#         "python3 -m venv venv",
#         "source venv/bin/activate",
#         "pip install --upgrade pip && pip install pyyaml paramiko",
#     ]
# }

# resource "spacelift_context" "spacectl" {
#     name = "spacectl"
#     description = "Runner Spacectl CLI"
#     space_id = data.spacelift_space.root.id
#     after_apply = [
#         "python3 ${path.module}/script/after_apply.py"
#     ]
# }

resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${path.module}/config/config.yaml > /mnt/workspace/config.yaml",
        "cat /mnt/workspace/config.yaml"
    ]
}

# resource "spacelift_context" "github" {
#     name = "github"
#     description = "Github configuration"
#     space_id = "root"
# }

# resource "spacelift_context" "proxmox" {
#     name = "proxmox"
#     description = "Proxmox configuration"
#     space_id = "root"
# }
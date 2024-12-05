resource "spacelift_stack" "proxmox" {
    count = var.FLAG_VALID_CONFIG >=1 ? 1 : 0
    administrative = true
    autodeploy = true
    branch = local.config.github.branch
    description = "Proxmox"
    name = "proxmox"
    project_root = "terraform/stack/proxmox"
    repository = local.config.github.repository
    terraform_version = "1.5.7"
    labels = ["spacelift", "init"]
    additional_project_globs = [ 
        "script/**",
        "config/**"
    ]
}


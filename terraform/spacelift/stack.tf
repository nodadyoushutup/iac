resource "spacelift_stack" "proxmox" {
    administrative = true
    autodeploy = true
    branch = local.github.branch
    description = "Proxmox"
    name = "proxmox"
    project_root = "terraform/proxmox"
    repository = local.github.repository
    runner_image = local.spacelift.runner_image
    terraform_version = "1.5.7"
    labels = ["proxmox"]
    additional_project_globs = [ 
        "script/**",
        "config/**"
    ]
}


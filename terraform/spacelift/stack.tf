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
        "file/**",
    ]
}

resource "spacelift_stack" "development" {
    administrative = true
    autodeploy = true
    branch = local.github.branch
    description = "Development"
    name = "development"
    project_root = "terraform/development"
    repository = local.github.repository
    runner_image = local.spacelift.runner_image
    terraform_version = "1.5.7"
    labels = ["development"]
    # additional_project_globs = [ 
    #     "file/**",
    # ]
}

# resource "spacelift_stack" "debug" {
#     administrative = true
#     autodeploy = true
#     branch = local.github.branch
#     description = "debug"
#     name = "debug"
#     project_root = "terraform/debug"
#     repository = local.github.repository
#     terraform_version = "1.5.7"
#     labels = ["debug"]
# }
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
    labels = ["terraform", "proxmox"]
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
    labels = ["terraform", "development"]
    # additional_project_globs = [ 
    #     "config/**",
    # ]
}

resource "spacelift_stack" "init" {
    administrative = true
    autodeploy = true
    branch = local.github.branch
    description = "Init"
    name = "init"
    project_root = "ansible/init"
    repository = local.github.repository
    runner_image = local.spacelift.runner_image
    labels = ["ansible", "init"]
    ansible {
        playbook = "main.yaml"
    }
}

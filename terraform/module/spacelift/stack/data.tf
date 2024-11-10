data "spacelift_context" "config" {
    context_id = "config"
}

data "spacelift_context" "terraform" {
    context_id = "terraform"
}

data "spacelift_context" "ansible" {
    context_id = "ansible"
}
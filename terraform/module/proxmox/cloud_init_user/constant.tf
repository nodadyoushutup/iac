locals { # Constant
    source = {
        talos    = "${path.module}/template/talos_config.yaml.tpl"
        gitconfig = "${path.module}/template/gitconfig.tpl"
    }
    type = can(regex("talos", var.name)) ? "talos" : "cloud" 
}

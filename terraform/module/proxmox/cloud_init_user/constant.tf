locals { # Constant
  source = {
    talos     = "${path.module}/template/talos_config.yaml.tpl"
    gitconfig = "${path.module}/template/gitconfig.tpl"
  }

  user_default = {
    name                = null
    doas                = null
    expiredate          = null
    gecos               = null
    groups              = null
    homedir             = null
    inactive            = null
    lock_passwd         = null
    no_create_home      = null
    no_log_init         = null
    no_user_group       = null
    passwd              = null
    hashed_passwd       = null
    plain_text_passwd   = null
    create_groups       = null
    primary_group       = null
    selinux_user        = null
    shell               = null
    snapuser            = null
    ssh_authorized_keys = null
    ssh_import_id       = null
    ssh_redirect_user   = null
    system              = null
    sudo                = null
    uid                 = null
  }
}

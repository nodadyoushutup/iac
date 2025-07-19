locals { # Commands
  runcmd_base = (local.gitconfig_computed.github_pat != null && local.users_computed != null && length(local.users_computed) > 0) ? [
    for user in local.users_computed : "su - ${user.name} -c \"/script/register_github_public_key.sh ${local.gitconfig_computed.github_pat}\""
  ] : []

  bootcmd_base = ["netplan apply"]
}

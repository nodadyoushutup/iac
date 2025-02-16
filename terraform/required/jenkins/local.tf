locals {
  directories = {
    required = toset([
      for dir in keys(data.external.list_dir_required.result) : dir
      if !can(regex("@", dir)) && !can(regex("jenkins", dir))
    ])
  }
}

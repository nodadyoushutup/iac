locals {
  directories = toset([
    for dir in keys(data.external.list_directories.result) : dir
    if !can(regex("@", dir)) && !can(regex("jenkins", dir))
  ])
}

locals {
  template = {
    pipeline = {
      proxmox = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/proxmox"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
    }
  }
}
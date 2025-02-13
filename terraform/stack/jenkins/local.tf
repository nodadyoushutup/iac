locals {
  template = {
    pipeline = {
      cadvisor = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/cadvisor"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
      dozzle = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/dozzle"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
      grafana = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/grafana"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
      prometheus = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/prometheus"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
      proxmox = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/proxmox"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
      talos = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/talos"
          GIT_REPOSITORY_BRANCH = var.GIT_REPOSITORY_BRANCH
          GIT_REPOSITORY_URL = var.GIT_REPOSITORY_URL
        }
      )
    }
  }
}
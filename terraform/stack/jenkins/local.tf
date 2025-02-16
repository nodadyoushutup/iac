locals {
  template = {
    pipeline = {
      cadvisor = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/cadvisor"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
      dozzle = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/dozzle"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
      grafana = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/grafana"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
      prometheus = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/prometheus"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
      proxmox = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/proxmox"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
      talos = templatefile(
        "${path.module}/template/job.xml.tpl", 
        {
          SUBDIR = "terraform/stack/talos"
          git.repository.branch = var.git.repository.branch
          git.repository.url = var.git.repository.url
        }
      )
    }
  }
}
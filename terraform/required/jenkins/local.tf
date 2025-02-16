# locals {
#   template = {
#     pipeline = {
#       cadvisor = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/cadvisor"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#       dozzle = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/dozzle"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#       grafana = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/grafana"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#       prometheus = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/prometheus"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#       proxmox = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/proxmox"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#       talos = templatefile(
#         "${path.module}/template/job.xml.tpl", 
#         {
#           SUBDIR = "terraform/required/talos"
#           git_repository_branch = var.git.repository.branch
#           git_repository_url = var.git.repository.url
#         }
#       )
#     }
#   }
# }
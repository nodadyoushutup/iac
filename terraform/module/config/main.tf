resource "jenkins_folder" "this" {
  count = var.enabled ? 1 : 0
  name  = var.folder_name
}

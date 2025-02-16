data "external" "list_directories" {
  program = ["bash", "${path.module}/script/list_dir_required.sh"]
}
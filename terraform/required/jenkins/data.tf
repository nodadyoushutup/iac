data "external" "list_dir_required" {
  program = ["bash", "${path.module}/script/list_dir_required.sh"]
}
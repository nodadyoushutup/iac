output "folder_id" {
  description = "ID of the managed Jenkins folder"
  value       = try(jenkins_folder.this[0].id, null)
}

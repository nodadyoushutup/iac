output "datasource_uids" {
  description = "Map of Grafana data source names to their UIDs"
  value       = { for name, ds in grafana_data_source.this : name => ds.uid }
}

output "folder_ids" {
  description = "Map of Grafana folder names to their IDs"
  value       = { for name, folder in grafana_folder.this : name => folder.id }
}

output "dashboard_uids" {
  description = "Map of dashboard keys to the resulting Grafana UID"
  value       = { for key, dashboard in grafana_dashboard.this : key => dashboard.uid }
}

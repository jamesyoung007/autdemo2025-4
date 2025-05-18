output "app_service_plan_id" {
  description = "ID of the App Service Plan."
  value       = module.app_service_plan.id
}

output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = module.storage_account.name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace."
  value       = module.log_analytics.id
}

output "function_app_name" {
  description = "Name of the Function App."
  value       = module.function_app.name
}

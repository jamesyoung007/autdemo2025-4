output "app_service_plan_id" {
  description = "ID of the App Service Plan."
  value       = azurerm_service_plan.plan.id
  depends_on  = [azurerm_service_plan.plan]
}

output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.storage.name
  depends_on  = [azurerm_storage_account.storage]
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.id
  depends_on  = [azurerm_log_analytics_workspace.law]
}

output "function_app_name" {
  description = "Name of the Function App."
  value       = azurerm_windows_function_app.function.name
  depends_on  = [azurerm_windows_function_app.function]
}

# AUTDEMO2025-4-5: Azure resources with CAF modules

This configuration deploys the following Azure resources using the official [CAF modules](https://github.com/aztfmod/terraform-azurerm-caf/tree/main/modules):
- App Service Plan
- Function App
- Log Analytics Workspace
- Storage Account

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- Azure CLI ([Install](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- Access to an Azure subscription

## Usage
1. Clone this repository and navigate to the `autdemo2025-4` folder.
2. Update `backend.tf` with your remote state resource group and storage account.
3. Set the required variables in a `terraform.tfvars` file or via environment variables.
4. Initialize Terraform:
   ```powershell
   terraform init
   ```
5. Validate the configuration:
   ```powershell
   terraform validate
   ```
6. Plan the deployment:
   ```powershell
   terraform plan
   ```
7. Apply the deployment:
   ```powershell
   terraform apply -auto-approve
   ```

## Security & Best Practices
- Uses Azure Managed Identity for authentication (no credentials in code)
- State is stored securely in Azure Storage
- Follows [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)
- Uses official CAF modules for consistency and compliance

## References
- [CAF modules](https://github.com/aztfmod/terraform-azurerm-caf/tree/main/modules)
- [Azure Portal](https://portal.azure.com/)
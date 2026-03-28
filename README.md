# Azure Resources Bootstrap Terraform

Infrastructure as Code (IaC) for bootstrapping foundational Azure resources required for secure, scalable, and maintainable cloud infrastructure deployments.

## Overview

This Terraform configuration creates the essential "bootstrap" resources needed before deploying application infrastructure. These resources provide the foundation for:

- **Remote State Management** - Secure storage for Terraform state files
- **Secrets Management** - Centralized storage for sensitive configuration
- **Resource Organization** - Logical grouping and access control
- **Multi-Environment Support** - Isolated environments with proper boundaries

## Architecture

```
Azure Subscription
├── Resource Group (bootstrapresource-rg)
│   ├── Storage Account (bootstrapresourcestrg)
│   │   └── Container (bootstrapresource-tfstate)
│   └── Key Vault (bootstrapresource-kv)
│       ├── Secret: user-name
│       └── Secret: user-password
```

## Resources Created

### Core Infrastructure
- **Resource Group**: `bootstrapresource-rg` - Central container for all bootstrap resources
- **Storage Account**: `bootstrapresourcestrg` - Standard LRS storage for Terraform state
- **Storage Container**: `bootstrapresource-tfstate` - Private container for state files
- **Key Vault**: `bootstrapresource-kv` - Standard SKU vault for secrets management

### Key Vault Secrets
- **user-name**: Default admin username (`adminuser`)
- **user-password**: Default admin password (securely stored)

## Prerequisites

### Required Tools
- **Terraform** >= 1.0.0
- **Azure CLI** - For authentication (`az login`)
- **Git** - For repository management

### Azure Permissions
The authenticated user/service principal must have:
- `Contributor` role on the target subscription
- Permission to create resource groups
- Permission to create storage accounts and key vaults

### Authentication
```bash
# Login to Azure CLI
az login

# Set the target subscription
az account set --subscription "bd7b142b-030a-46e3-8a31-579ffb9d2046"
```

## Project Structure

```
bootstrap-azure-resources-terraform/
├── terraform/                          # Terraform configuration
│   ├── main.tf                        # Resource definitions
│   ├── variables.tf                   # Input variables
│   ├── terraform.tfvars              # Variable values
│   ├── outputs.tf                    # Output values
│   ├── provider.tf                   # Azure provider config
│   ├── data.tf                       # Data sources
│   └── .terraform/                   # Terraform working directory
├── LICENSE                           # Apache License 2.0
├── README.md                         # This documentation
└── .gitignore                       # Git ignore rules
```

## Configuration

### Input Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `subscription_id` | string | Azure subscription ID | Required |
| `resource_group` | string | Base name for resources | Required |
| `location` | string | Azure region | Required |

### Default Configuration

```hcl
subscription_id = "bd7b142b-030a-46e3-8a31-579ffb9d2046"
resource_group  = "bootstrapresource"
location        = "centralindia"
```

### Resource Naming Convention

All resources follow a consistent naming pattern:
- **Resource Group**: `{resource_group}-rg`
- **Storage Account**: `{resource_group}strg`
- **Storage Container**: `{resource_group}-tfstate`
- **Key Vault**: `{resource_group}-kv`

## Deployment

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/anurag-devops-principles/bootstrap-azure-resources-terraform.git
   cd bootstrap-azure-resources-terraform/terraform
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

### Detailed Deployment Steps

#### Step 1: Authentication
```bash
# Authenticate with Azure
az login

# Verify authentication
az account show
```

#### Step 2: Configuration
```bash
# Navigate to terraform directory
cd terraform

# Review and modify terraform.tfvars if needed
cat terraform.tfvars
```

#### Step 3: Initialize
```bash
# Download providers and initialize
terraform init
```

#### Step 4: Validate
```bash
# Check configuration syntax
terraform validate

# Review planned changes
terraform plan
```

#### Step 5: Deploy
```bash
# Apply the configuration
terraform apply

# Confirm with 'yes' when prompted
```

## Outputs

After successful deployment, the following outputs are available:

| Output | Description | Example |
|--------|-------------|---------|
| `resource_group_name` | Resource group name | `bootstrapresource-rg` |
| `storage_account_name` | Storage account name | `bootstrapresourcestrg` |
| `storage_container_name` | Storage container name | `bootstrapresource-tfstate` |
| `key_vault_name` | Key Vault name | `bootstrapresource-kv` |

### Using Outputs

```bash
# View all outputs
terraform output

# Get specific output
terraform output resource_group_name

# Use in scripts
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
```

## Usage in Other Projects

### Remote State Configuration

Use the created storage account for remote state in other Terraform projects:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "bootstrapresource-rg"
    storage_account_name = "bootstrapresourcestrg"
    container_name       = "bootstrapresource-tfstate"
    key                  = "your-project.tfstate"
  }
}
```

### Key Vault Integration

Reference the Key Vault for secrets management:

```hcl
data "azurerm_key_vault" "bootstrap" {
  name                = "bootstrapresource-kv"
  resource_group_name = "bootstrapresource-rg"
}

data "azurerm_key_vault_secret" "admin_username" {
  name         = "user-name"
  key_vault_id = data.azurerm_key_vault.bootstrap.id
}
```

## Security Considerations

### Key Vault Configuration
- **Soft Delete**: Enabled with 7-day retention
- **Purge Protection**: Disabled for development flexibility
- **Access Policies**: Owner has full secret permissions
- **SKU**: Standard tier (cost-effective for bootstrap)

### Secrets Management
- Default credentials are provided for initial setup
- **Never commit real secrets** to version control
- Rotate default passwords after initial deployment
- Use Key Vault references in production applications

### Network Security
- Storage account containers are private
- Key Vault access is restricted to authorized principals
- Resources are created in the specified region only

## Cost Optimization

### Resource Costs
- **Resource Group**: Free
- **Storage Account**: ~$0.02/GB/month (LRS)
- **Key Vault**: ~$0.03/10,000 operations
- **Total Monthly Cost**: <$1 for basic usage

### Cleanup
```bash
# Destroy all resources
terraform destroy

# Confirm destruction when prompted
```

## Best Practices

### Environment Management
- Use separate bootstrap resources per environment
- Maintain consistent naming conventions
- Document resource relationships

### State Management
- Always use remote state for team collaboration
- Enable state locking to prevent concurrent modifications
- Regularly backup state files

### Security
- Rotate service principal credentials regularly
- Use Azure RBAC for granular access control
- Enable Azure Monitor and logging

### Version Control
- Commit Terraform code without sensitive values
- Use `.gitignore` for `.terraform/` and `terraform.tfstate`
- Tag releases for infrastructure versioning

## Troubleshooting

### Common Issues

**Authentication Errors**:
```bash
# Re-authenticate
az login

# Check account
az account show

# Set correct subscription
az account set --subscription "your-subscription-id"
```

**Permission Denied**:
- Verify user has Contributor role on subscription
- Check Azure role assignments
- Ensure service principal has correct scope

**Resource Conflicts**:
- Check for existing resources with same names
- Use unique resource group names
- Verify region availability

**State Lock Issues**:
- Check for long-running operations
- Force unlock if necessary (use with caution)
- Coordinate with team members

### Validation Commands

```bash
# Check syntax
terraform validate

# Format code
terraform fmt

# Check for updates
terraform plan -refresh-only
```

## Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/new-resource`
3. **Make changes** following Terraform best practices
4. **Test locally**: `terraform plan` and `terraform apply`
5. **Commit changes**: `git commit -m 'Add new bootstrap resource'`
6. **Push and create PR**

### Guidelines
- Follow Terraform style conventions
- Add appropriate variables and outputs
- Update documentation for new resources
- Test in non-production subscription first

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Support

For issues and questions:
- Check existing [GitHub Issues](../../issues)
- Review Azure Terraform documentation
- Contact the infrastructure team

---

**Author**: Anurag Vijay
**Last Updated**: March 2026

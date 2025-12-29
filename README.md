# terraform-bootstrap-resources

## Overview

This repository contains Terraform code to bootstrap foundational resources required for initializing and managing infrastructure deployments in Azure. It is designed to help teams quickly set up the essential building blocks for secure, scalable, and maintainable cloud environments.

## Features

- Automated provisioning of core Azure resources
- Modular and reusable Terraform code
- Supports remote state management
- Output of key resource information for downstream use

## Resources Created

The typical resources provisioned by this module include (but are not limited to):

- Resource Group
- Storage Account (for remote state)
- State Container
- Key Vault (for secrets management)
- (Extendable for other foundational resources)

## Repository Structure

```
terraform-bootstrap-resources/
├── data.tf                # Data sources definitions
├── main.tf                # Main resource definitions
├── output.tf              # Output variables
├── provider.tf            # Provider configuration
├── variable.tf            # Input variables
├── terraform.tfvars       # Example variable values
├── terraform.tfstate*     # Terraform state files (should be remote in production)
├── README.md              # Project documentation
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- Azure subscription and credentials with sufficient permissions

## Usage

1. Clone this repository:
	```sh
	git clone <repo-url>
	cd terraform-bootstrap-resources
	```
2. Initialize Terraform:
	```sh
	terraform init
	```
3. Review and update `terraform.tfvars` or provide your own variable values.
4. Plan the deployment:
	```sh
	terraform plan
	```
5. Apply the configuration:
	```sh
	terraform apply
	```

## Inputs

See `variable.tf` for a full list of configurable input variables.

## Outputs

See `output.tf` for a full list of outputs provided after deployment.

## Best Practices

- Use remote state storage for production deployments.
- Store sensitive values in Azure Key Vault.
- Use separate state files for different environments (dev, staging, prod).

## License

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

## Authors

- [Anurag Vijay]

---

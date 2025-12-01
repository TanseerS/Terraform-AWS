# Day-7 Terraform

This directory provisions example AWS resources demonstrating various Terraform variable types and validations.

Quick usage

```bash
cd /Users/tanseer/Desktop/Personal/Terraform-AWS/Day-7
# Initialize providers and modules
terraform init

# Validate configuration
terraform validate

# See the planned changes (you can set/override variables here)
terraform plan -out=tfplan

# Apply the planned changes
terraform apply "tfplan"

# Or run plan/apply directly
terraform plan
terraform apply
```

Override variables inline (example):

```bash
terraform plan -var 'region=eu-west-1' -var 'environment=prod' -var 'instance_count=2'
terraform apply -var 'region=eu-west-1' -var 'environment=prod' -var 'instance_count=2'
```

Notes

- `var.region` is validated against `var.allowed_region`.
- `var.instance_type` is validated against `var.allowed_vm_types`.
- The S3 bucket name uses `var.environment` as a mandatory prefix and a random suffix to improve uniqueness.
- Outputs include `deployment_summary` and `vpc_name`.

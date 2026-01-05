# HCP Terraform Demo

## Overview
HashiCorp Cloud Platform (HCP) provides managed Terraform services for infrastructure as code.

## Setup
1. Sign up at https://app.terraform.io
2. Create an organization
3. Generate API token in User Settings > Tokens

## Demo Steps
1. Create a workspace in HCP
2. Configure backend in Terraform:

```hcl
terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "demo-workspace"
    }
  }
}
```

3. Authenticate:
```bash
terraform login
```

4. Initialize:
```bash
terraform init
```

5. Plan and apply:
```bash
terraform plan
terraform apply
```

## Key Features
- Remote state management
- Version control integration
- Run triggers
- Policy enforcement
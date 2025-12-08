Day-13: Using data sources to reference existing VPC and Subnet

This folder demonstrates how to use Terraform data sources to discover existing AWS infrastructure and provision an EC2 instance into a pre-existing VPC/subnet.

Usage (minimal):

```bash
cd /Users/tanseer/Desktop/Personal/Terraform-AWS/Day-13
# Edit variables.tf to set either vpc_id or vpc_tag, and either subnet_id or subnet_tag.
terraform init
terraform plan -out=tfplan
# Review tfplan to ensure correct VPC/subnet are selected before applying
terraform apply "tfplan"
```

Notes:
- The code prefers explicit `vpc_id`/`subnet_id` when provided.
- If tags are provided (`vpc_tag` or `subnet_tag`), those are used to look up resources.
- If no subnet is provided, the code attempts to pick the first subnet in the discovered VPC.
- This demo creates a simple security group in the existing VPC and launches an EC2 instance into the selected subnet.

Be cautious when running in production accounts — verify the selected VPC/subnet before applying.

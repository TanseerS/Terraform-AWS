# AWS SSO Setup
resource "aws_ssoadmin_permission_set" "admin" {
  name         = "AdministratorAccess"
  description  = "Provides full access to AWS services and resources"
  instance_arn = aws_ssoadmin_instances.sso.arns[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_policy" {
  instance_arn       = aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Note: In production, assign to users/groups via aws_ssoadmin_account_assignment
# For simplicity, just creating the permission set

data "aws_ssoadmin_instances" "sso" {}

# If no SSO instance exists, you might need to create one manually or use aws_ssoadmin_instance
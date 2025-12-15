# Get AWS Account ID
data "aws_caller_identity" "current" {}

# Output the account ID
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Read users from CSV
locals {
  users = csvdecode(file("users.csv"))
}

# Output user names
output "user_names" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

# Create IAM users
resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")
  path = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department"  = each.value.department
    "JobTitle"    = each.value.job_title
    "Email"       = each.value.email
    "Phone"       = each.value.phone
  }
}

# Create IAM user login profile (password)
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

# Create virtual MFA devices for users
resource "aws_iam_virtual_mfa_device" "users_mfa" {
  for_each = aws_iam_user.users

  virtual_mfa_device_name = each.value.name
  path                    = "/users/"
}

output "user_passwords" {
  value = {
    for user, profile in aws_iam_user_login_profile.users :
    user => "Password created - user must reset on first login"
  }
  sensitive = true
}

output "mfa_devices" {
  value = {
    for user, mfa in aws_iam_virtual_mfa_device.users_mfa :
    user => {
      serial_number = mfa.serial_number
      base32_string_seed = mfa.base32_string_seed
    }
  }
  sensitive = true
}
output "user_emails" {
  value = [for user in local.users : user.email]
}

output "user_phones" {
  value = [for user in local.users : user.phone]
}

output "mfa_serial_numbers" {
  value = [for mfa in aws_iam_virtual_mfa_device.users_mfa : mfa.serial_number]
  sensitive = true
}

output "sso_permission_set_arn" {
  value = aws_ssoadmin_permission_set.admin.arn
}
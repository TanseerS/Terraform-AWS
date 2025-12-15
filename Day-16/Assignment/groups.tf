# Create IAM Groups
resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

# Add users to the Education group
resource "aws_iam_group_membership" "education_members" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
  ]
}

# Add users to the Managers group
resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
}

# Add users to the Engineers group
resource "aws_iam_group_membership" "engineers_members" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Engineering" # Note: No users match this in the current CSV
  ]
}

# Attach policies to groups
resource "aws_iam_group_policy_attachment" "managers_admin" {
  group      = aws_iam_group.managers.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "education_readonly" {
  group      = aws_iam_group.education.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "engineers_developer" {
  group      = aws_iam_group.engineers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# MFA enforcement policy
resource "aws_iam_policy" "mfa_enforce" {
  name        = "MFAEnforcePolicy"
  description = "Policy to enforce MFA"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Attach MFA policy to all groups
resource "aws_iam_group_policy_attachment" "education_mfa" {
  group      = aws_iam_group.education.name
  policy_arn = aws_iam_policy.mfa_enforce.arn
}

resource "aws_iam_group_policy_attachment" "managers_mfa" {
  group      = aws_iam_group.managers.name
  policy_arn = aws_iam_policy.mfa_enforce.arn
}

resource "aws_iam_group_policy_attachment" "engineers_mfa" {
  group      = aws_iam_group.engineers.name
  policy_arn = aws_iam_policy.mfa_enforce.arn
}
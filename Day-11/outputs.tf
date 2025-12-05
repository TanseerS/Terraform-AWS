output "assignment_1_project_slug" {
  value = local.project_slug
  description = "Project name transformed to slug (lowercase, dashes)"
}

output "assignment_2_merged_tags" {
  value = local.merged_tags
  description = "Default tags merged with environment tags"
}

output "assignment_3_sanitized_bucket" {
  value = local.sanitized_bucket
  description = "Sanitized bucket name (lower, replace, truncated to 63 chars)"
}

output "assignment_4_sg_rules" {
  value = local.sg_rules
  description = "Security group rules derived from CSV ports"
}

output "assignment_4_joined_ports" {
  value = local.joined_ports
  description = "Joined ports string (for demonstration)"
}

output "assignment_5_instance_size" {
  value = local.instance_size
  description = "Instance size selected by environment lookup"
}

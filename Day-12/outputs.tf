output "assignment_6_instance_valid" {
  value       = local.instance_valid
  description = "Boolean indicating the instance type format is valid"
}

output "assignment_7_backup_name_valid" {
  value       = local.backup_name_valid
  description = "Whether backup name ends with '-bak'"
}

output "assignment_7_backup_secret" {
  value       = local.backup_secret
  description = "Sensitive backup password (marked sensitive)"
  sensitive   = true
}

output "assignment_8_config_exists" {
  value       = local.config_exists
  description = "Whether the config file exists"
}

output "assignment_8_config_dir" {
  value       = local.config_dir
  description = "Directory name of the config file (if exists)"
}

output "assignment_9_combined_regions" {
  value       = local.combined_regions
  description = "Combined set of regions with duplicates removed"
}

output "assignment_10_total_costs" {
  value       = local.total_costs
  description = "Sum of cost items"
}

output "assignment_10_net_cost" {
  value       = local.net_cost
  description = "Net cost after credits (not negative)"
}

output "assignment_10_abs_raw" {
  value       = local.abs_raw
  description = "Absolute value of raw cost minus credits"
}

output "assignment_11_timestamp" {
  value       = local.now_ts
  description = "Current timestamp"
}

output "assignment_11_formatted_date" {
  value       = local.today_date
  description = "Formatted date (YYYY-MM-DD)"
}

output "assignment_12_json_exists" {
  value       = local.json_exists
  description = "Whether the JSON config file was found"
}

output "assignment_12_parsed_json" {
  value       = local.parsed_json
  description = "Parsed JSON config (not sensitive)"
}

output "assignment_12_encoded_json_secret" {
  value       = local.secret_json
  description = "Encoded JSON stored as a sensitive value"
  sensitive   = true
}

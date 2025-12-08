locals {
  # Assignment 6: Instance Validation
  instance_valid = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type)) && length(var.instance_type) > 0

  # Assignment 7: Backup Configuration
  backup_name_valid = endswith(var.backup_name, "-bak")
  backup_secret     = sensitive(var.backup_password)

  # Assignment 8: File Path Processing
  config_exists = fileexists(var.config_path)
  config_dir    = config_exists ? dirname(var.config_path) : ""

  # Assignment 9: Location Management
  combined_regions = toset(concat(var.regions_a, var.regions_b))

  # Assignment 10: Cost Calculation
  total_costs   = sum(var.costs)
  total_credits = sum(var.credits)
  raw_net       = total_costs - total_credits
  net_cost      = max(0, raw_net)
  abs_raw       = abs(raw_net)

  # Assignment 11: Timestamp Management
  now_ts        = timestamp()
  today_date    = formatdate("YYYY-MM-DD", local.now_ts)

  # Assignment 12: File Content Handling
  json_exists   = fileexists(var.json_config_path)
  raw_json      = json_exists ? file(var.json_config_path) : ""
  parsed_json   = json_exists ? jsondecode(local.raw_json) : {}
  encoded_json  = json_exists ? jsonencode(local.parsed_json) : ""
  secret_json   = json_exists ? sensitive(local.encoded_json) : ""
}

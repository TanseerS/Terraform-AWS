locals {
  // Assignment 1: Project Naming — lower and replace spaces with '-'
  project_slug = lower(replace(var.project_name, " ", "-"))

  // Assignment 2: Merge default and environment tags
  merged_tags = merge(var.default_tags, var.env_tags)

  // Assignment 3: Sanitize bucket name: replace spaces and underscores, lowercase, then truncate to 63 chars
  sanitized_bucket = substr(lower(replace(replace(var.raw_bucket, " ", "-"), "_", "-")), 0, 63)

  // Assignment 4: Security group ports — split CSV into list and build rules
  ports_list = split(",", var.ports_csv)
  sg_rules = [for p in local.ports_list : {
    from_port = tonumber(p)
    to_port   = tonumber(p)
    protocol  = "tcp"
  }]

  joined_ports = join(",", local.ports_list)

  // Assignment 5: Environment lookup for instance size
  size_map = { dev = "t2.micro", staging = "t3.small", prod = "t3.large" }
  instance_size = lookup(local.size_map, var.environment, "t2.micro")
}

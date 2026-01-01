output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "nat_gateway_ips" {
  value = aws_eip.nat[*].public_ip
}
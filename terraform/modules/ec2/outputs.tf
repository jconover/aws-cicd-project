output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.web.zone_id
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

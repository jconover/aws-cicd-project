output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.web.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.web.id
}

output "load_balancer_dns" {
  description = "DNS name of the ECS load balancer"
  value       = aws_lb.ecs.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the ECS load balancer"
  value       = aws_lb.ecs.zone_id
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.web.arn
}

output "vpc_id_primary" {
  description = "ID of the primary VPC"
  value       = module.vpc_primary.vpc_id
}

output "vpc_id_secondary" {
  description = "ID of the secondary VPC"
  value       = module.vpc_secondary.vpc_id
}

output "vpc_id_tertiary" {
  description = "ID of the tertiary VPC"
  value       = module.vpc_tertiary.vpc_id
}

output "public_subnets_primary" {
  description = "List of primary region public subnet IDs"
  value       = module.vpc_primary.public_subnets
}

output "private_subnets_primary" {
  description = "List of primary region private subnet IDs"
  value       = module.vpc_primary.private_subnets
}

output "ec2_auto_scaling_group_name_primary" {
  description = "Name of the primary EC2 Auto Scaling Group"
  value       = module.ec2_primary.auto_scaling_group_name
}

output "ec2_auto_scaling_group_name_secondary" {
  description = "Name of the secondary EC2 Auto Scaling Group"
  value       = module.ec2_secondary.auto_scaling_group_name
}

output "ec2_auto_scaling_group_name_tertiary" {
  description = "Name of the tertiary EC2 Auto Scaling Group"
  value       = module.ec2_tertiary.auto_scaling_group_name
}

output "ecs_cluster_name_primary" {
  description = "Name of the primary ECS cluster"
  value       = var.enable_ecs ? module.ecs_primary[0].cluster_name : null
}

output "ecs_cluster_name_secondary" {
  description = "Name of the secondary ECS cluster"
  value       = var.enable_ecs ? module.ecs_secondary[0].cluster_name : null
}

output "ecs_cluster_name_tertiary" {
  description = "Name of the tertiary ECS cluster"
  value       = var.enable_ecs ? module.ecs_tertiary[0].cluster_name : null
}

output "eks_cluster_name_primary" {
  description = "Name of the primary EKS cluster"
  value       = var.enable_eks ? module.eks_primary[0].cluster_name : null
}

output "eks_cluster_name_secondary" {
  description = "Name of the secondary EKS cluster"
  value       = var.enable_eks ? module.eks_secondary[0].cluster_name : null
}

output "eks_cluster_name_tertiary" {
  description = "Name of the tertiary EKS cluster"
  value       = var.enable_eks ? module.eks_tertiary[0].cluster_name : null
}

output "ecr_repository_url_primary" {
  description = "URL of the primary ECR repository"
  value       = aws_ecr_repository.app_repo_primary.repository_url
}

output "ecr_repository_url_secondary" {
  description = "URL of the secondary ECR repository"
  value       = aws_ecr_repository.app_repo_secondary.repository_url
}

output "ecr_repository_url_tertiary" {
  description = "URL of the tertiary ECR repository"
  value       = aws_ecr_repository.app_repo_tertiary.repository_url
}

output "load_balancer_dns_primary" {
  description = "DNS name of the primary region load balancer"
  value       = module.ec2_primary.load_balancer_dns
}

output "load_balancer_dns_secondary" {
  description = "DNS name of the secondary region load balancer"
  value       = module.ec2_secondary.load_balancer_dns
}

output "load_balancer_dns_tertiary" {
  description = "DNS name of the tertiary region load balancer"
  value       = module.ec2_tertiary.load_balancer_dns
}

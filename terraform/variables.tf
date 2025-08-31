# Region Configuration
variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for failover"
  type        = string
  default     = "us-east-2"
}

variable "tertiary_region" {
  description = "Tertiary AWS region for additional redundancy"
  type        = string
  default     = "us-west-2"
}

# VPC CIDR blocks for each region
variable "primary_vpc_cidr" {
  description = "CIDR block for primary region VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for secondary region VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "tertiary_vpc_cidr" {
  description = "CIDR block for tertiary region VPC"
  type        = string
  default     = "10.2.0.0/16"
}

# Global Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "cicd-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Domain name for the application (optional)"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "EC2 Key Pair name (must exist in all regions)"
  type        = string
}

# Feature flags
variable "enable_ecs" {
  description = "Enable ECS clusters"
  type        = bool
  default     = true
}

variable "enable_eks" {
  description = "Enable EKS clusters"
  type        = bool
  default     = true
}

variable "enable_cross_region_replication" {
  description = "Enable cross-region data replication"
  type        = bool
  default     = true
}

# Primary region capacity
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_capacity" {
  description = "Minimum number of EC2 instances in primary region"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of EC2 instances in primary region"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in primary region"
  type        = number
  default     = 3
}

# Standby region capacity (typically lower)
variable "standby_min_capacity" {
  description = "Minimum number of EC2 instances in standby regions"
  type        = number
  default     = 1
}

variable "standby_max_capacity" {
  description = "Maximum number of EC2 instances in standby regions"
  type        = number
  default     = 6
}

variable "standby_desired_capacity" {
  description = "Desired number of EC2 instances in standby regions"
  type        = number
  default     = 1
}

# ECS Configuration
variable "ecs_desired_count" {
  description = "Desired number of ECS tasks in primary region"
  type        = number
  default     = 3
}

variable "standby_ecs_desired_count" {
  description = "Desired number of ECS tasks in standby regions"
  type        = number
  default     = 1
}

# EKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "node_desired_size" {
  description = "Desired number of EKS nodes in primary region"
  type        = number
  default     = 3
}

variable "node_max_size" {
  description = "Maximum number of EKS nodes in primary region"
  type        = number
  default     = 6
}

variable "node_min_size" {
  description = "Minimum number of EKS nodes in primary region"
  type        = number
  default     = 1
}

variable "standby_node_desired_size" {
  description = "Desired number of EKS nodes in standby regions"
  type        = number
  default     = 1
}

variable "standby_node_max_size" {
  description = "Maximum number of EKS nodes in standby regions"
  type        = number
  default     = 3
}

variable "standby_node_min_size" {
  description = "Minimum number of EKS nodes in standby regions"
  type        = number
  default     = 1
}

variable "node_instance_types" {
  description = "EKS node instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

# CI/CD Configuration
variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "deployment_strategy" {
  description = "Deployment strategy: active-active or active-passive"
  type        = string
  default     = "active-passive"
  validation {
    condition     = contains(["active-active", "active-passive"], var.deployment_strategy)
    error_message = "Deployment strategy must be either 'active-active' or 'active-passive'."
  }
}
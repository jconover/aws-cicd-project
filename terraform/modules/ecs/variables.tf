variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "region_suffix" {
  description = "Region suffix for naming"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

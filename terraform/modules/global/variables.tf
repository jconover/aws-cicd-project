variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = ""
}

variable "primary_alb_dns" {
  description = "DNS name of the primary region ALB"
  type        = string
}

variable "secondary_alb_dns" {
  description = "DNS name of the secondary region ALB"
  type        = string
}

variable "tertiary_alb_dns" {
  description = "DNS name of the tertiary region ALB"
  type        = string
}

variable "primary_ecs_alb_dns" {
  description = "DNS name of the primary region ECS ALB"
  type        = string
  default     = null
}

variable "secondary_ecs_alb_dns" {
  description = "DNS name of the secondary region ECS ALB"
  type        = string
  default     = null
}

variable "tertiary_ecs_alb_dns" {
  description = "DNS name of the tertiary region ECS ALB"
  type        = string
  default     = null
}

variable "enable_cross_region_replication" {
  description = "Enable cross-region S3 replication"
  type        = bool
  default     = true
}

# Data sources for availability zones
data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"
}

data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"
}

data "aws_availability_zones" "tertiary" {
  provider = aws.tertiary
  state    = "available"
}

data "aws_caller_identity" "current" {}

# Primary Region Infrastructure
module "vpc_primary" {
  source = "./modules/vpc"
  providers = {
    aws = aws.primary
  }

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.primary_vpc_cidr
  availability_zones = slice(data.aws_availability_zones.primary.names, 0, 3)
  region_suffix      = "primary"
}

module "ec2_primary" {
  source = "./modules/ec2"
  providers = {
    aws = aws.primary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_primary.vpc_id
  public_subnets  = module.vpc_primary.public_subnets
  private_subnets = module.vpc_primary.private_subnets
  key_pair_name   = var.key_pair_name
  region_suffix   = "primary"

  instance_type    = var.instance_type
  min_capacity     = var.min_capacity
  max_capacity     = var.max_capacity
  desired_capacity = var.desired_capacity
}

module "ecs_primary" {
  count  = var.enable_ecs ? 1 : 0
  source = "./modules/ecs"
  providers = {
    aws = aws.primary
  }

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc_primary.vpc_id
  public_subnets = module.vpc_primary.public_subnets
  region_suffix  = "primary"
  desired_count  = var.ecs_desired_count
}

module "eks_primary" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"
  providers = {
    aws = aws.primary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_primary.vpc_id
  public_subnets  = module.vpc_primary.public_subnets
  private_subnets = module.vpc_primary.private_subnets
  region_suffix   = "primary"

  kubernetes_version  = var.kubernetes_version
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_min_size       = var.node_min_size
  node_instance_types = var.node_instance_types
}

# SECONDARY REGION INFRASTRUCTURE (us-east-2)
module "vpc_secondary" {
  source = "./modules/vpc"
  providers = {
    aws = aws.secondary
  }

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.secondary_vpc_cidr
  availability_zones = slice(data.aws_availability_zones.secondary.names, 0, 3)
  region_suffix      = "secondary"
}

module "ec2_secondary" {
  source = "./modules/ec2"
  providers = {
    aws = aws.secondary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_secondary.vpc_id
  public_subnets  = module.vpc_secondary.public_subnets
  private_subnets = module.vpc_secondary.private_subnets
  key_pair_name   = var.key_pair_name
  region_suffix   = "secondary"

  instance_type    = var.instance_type
  min_capacity     = var.standby_min_capacity
  max_capacity     = var.standby_max_capacity
  desired_capacity = var.standby_desired_capacity
}

module "ecs_secondary" {
  count  = var.enable_ecs ? 1 : 0
  source = "./modules/ecs"
  providers = {
    aws = aws.secondary
  }

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc_secondary.vpc_id
  public_subnets = module.vpc_secondary.public_subnets
  region_suffix  = "secondary"
  desired_count  = var.standby_ecs_desired_count
}

module "eks_secondary" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"
  providers = {
    aws = aws.secondary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_secondary.vpc_id
  public_subnets  = module.vpc_secondary.public_subnets
  private_subnets = module.vpc_secondary.private_subnets
  region_suffix   = "secondary"

  kubernetes_version  = var.kubernetes_version
  node_desired_size   = var.standby_node_desired_size
  node_max_size       = var.standby_node_max_size
  node_min_size       = var.standby_node_min_size
  node_instance_types = var.node_instance_types
}

# TERTIARY REGION INFRASTRUCTURE (us-west-2)
module "vpc_tertiary" {
  source = "./modules/vpc"
  providers = {
    aws = aws.tertiary
  }

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.tertiary_vpc_cidr
  availability_zones = slice(data.aws_availability_zones.tertiary.names, 0, 3)
  region_suffix      = "tertiary"
}

module "ec2_tertiary" {
  source = "./modules/ec2"
  providers = {
    aws = aws.tertiary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_tertiary.vpc_id
  public_subnets  = module.vpc_tertiary.public_subnets
  private_subnets = module.vpc_tertiary.private_subnets
  key_pair_name   = var.key_pair_name
  region_suffix   = "tertiary"

  instance_type    = var.instance_type
  min_capacity     = var.standby_min_capacity
  max_capacity     = var.standby_max_capacity
  desired_capacity = var.standby_desired_capacity
}

module "ecs_tertiary" {
  count  = var.enable_ecs ? 1 : 0
  source = "./modules/ecs"
  providers = {
    aws = aws.tertiary
  }

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc_tertiary.vpc_id
  public_subnets = module.vpc_tertiary.public_subnets
  region_suffix  = "tertiary"
  desired_count  = var.standby_ecs_desired_count
}

module "eks_tertiary" {
  count  = var.enable_eks ? 1 : 0
  source = "./modules/eks"
  providers = {
    aws = aws.tertiary
  }

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc_tertiary.vpc_id
  public_subnets  = module.vpc_tertiary.public_subnets
  private_subnets = module.vpc_tertiary.private_subnets
  region_suffix   = "tertiary"

  kubernetes_version  = var.kubernetes_version
  node_desired_size   = var.standby_node_desired_size
  node_max_size       = var.standby_node_max_size
  node_min_size       = var.standby_node_min_size
  node_instance_types = var.node_instance_types
}

# ECR Repositories in each region
resource "aws_ecr_repository" "app_repo_primary" {
  provider             = aws.primary
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "app_repo_secondary" {
  provider             = aws.secondary
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "app_repo_tertiary" {
  provider             = aws.tertiary
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Cross-region ECR replication
resource "aws_ecr_replication_configuration" "example" {
  provider = aws.primary

  replication_configuration {
    rule {
      destination {
        region      = var.secondary_region
        registry_id = data.aws_caller_identity.current.account_id
      }

      repository_filter {
        filter      = "${var.project_name}-app"
        filter_type = "PREFIX_MATCH"
      }
    }

    rule {
      destination {
        region      = var.tertiary_region
        registry_id = data.aws_caller_identity.current.account_id
      }

      repository_filter {
        filter      = "${var.project_name}-app"
        filter_type = "PREFIX_MATCH"
      }
    }
  }
}

# GLOBAL INFRASTRUCTURE
module "global_infrastructure" {
  source = "./modules/global"
  providers = {
    aws = aws.global
  }

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name

  # Load balancer endpoints from each region
  primary_alb_dns   = module.ec2_primary.load_balancer_dns
  secondary_alb_dns = module.ec2_secondary.load_balancer_dns
  tertiary_alb_dns  = module.ec2_tertiary.load_balancer_dns

  # ECS load balancer endpoints
  primary_ecs_alb_dns   = var.enable_ecs ? module.ecs_primary[0].load_balancer_dns : null
  secondary_ecs_alb_dns = var.enable_ecs ? module.ecs_secondary[0].load_balancer_dns : null
  tertiary_ecs_alb_dns  = var.enable_ecs ? module.ecs_tertiary[0].load_balancer_dns : null
}
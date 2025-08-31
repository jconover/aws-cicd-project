terraform {
    required_version = ">1.0"
    required_providerss {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Primary Region Provider (us-east-1)
provider "aws" {
    alias = "primary"
    region = "var.primary_region

    default_tags {
        tags = {
            Environment = var.environment
            Project = var.project_name
            Region = var.primary_region
            ManagedBy = "Terraform"
        }
    }
}

# Secondary Region Provider (us-east-2)
provider "aws" {
    alias = "secondary"
    region = var.secondary_region

    default_tags {
        tags = {
            Environment = var.environment
            Project = var.project_name
            Region = var.secondary_region
            ManagedBy = "Terraform"
        }
    }
}

# Tertiary Region Provider (us-west-2)
provider "aws" {
    alias = "tertiary"
    region = var.tertiary_region

    default_tags {
        tags = {
            Environment = var.environment
            Project = var.project_name
            Region = var.tertiary_region
            ManagedBy = "Terraform"
        }
    }
}

# Global services (Route53, CloudFront, ect..)
provider "aws" {
    alias = "global"
    region = "us-east-1"
}
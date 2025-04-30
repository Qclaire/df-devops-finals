terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "tech4dev-microservices-app-prod-tf-state"
    key    = "state/terraform.tfstate"
    region = "eu-west-1" 
  }
}

provider "aws" {
  region = var.aws_region
}
module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "${var.project_name}-${var.environment}"
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.private_subnet_ids
  node_instance_type = var.eks_node_instance_type
  node_desired_size  = var.eks_node_desired_size
  node_max_size      = var.eks_node_max_size
  node_min_size      = var.eks_node_min_size
  environment        = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  repository_names = [
    "${var.project_name}-go-service",
    "${var.project_name}-python-service",
    "${var.project_name}-rails-service"
  ]
  environment = var.environment
}

module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment
}

# just to trigger the creation of the secrets
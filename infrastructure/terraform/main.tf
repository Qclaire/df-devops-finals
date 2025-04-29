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

  

#   backend "s3" {
#     # for aws:
#     # bucket         = "terraform-state-bucket"
#     # key            = "microservices-app/terraform.tfstate"
#     # region         = "us-east-1"
#     # dynamodb_table = "terraform-lock"
    
#     # For local development with LocalStack:
#     bucket                      = "terraform-state-bucket"
#     key                         = "microservices-app/terraform.tfstate"
#     region                      = "us-east-1"
#     endpoint                    = "http://localhost:4566"
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     force_path_style            = true
#     dynamodb_table              = "terraform-lock"
#     dynamodb_endpoint           = "http://localhost:4566"
#   }
}

# # Provider configuration with conditional endpoint for LocalStack
provider "aws" {
   region = var.aws_region
  
  # Use these settings for LocalStack (local development)
  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      apigateway     = "http://localhost:4566"
      cloudformation = "http://localhost:4566"
      cloudwatch     = "http://localhost:4566"
      dynamodb       = "http://localhost:4566"
      ec2            = "http://localhost:4566"
      ecs            = "http://localhost:4566"
      ecr            = "http://localhost:4566"
      iam            = "http://localhost:4566"
      lambda         = "http://localhost:4566"
      route53        = "http://localhost:4566"
      s3             = "http://localhost:4566"
      secretsmanager = "http://localhost:4566"
      ses            = "http://localhost:4566"
      sns            = "http://localhost:4566"
      sqs            = "http://localhost:4566"
      ssm            = "http://localhost:4566"
      stepfunctions  = "http://localhost:4566"
      sts            = "http://localhost:4566"
    }
}
  
  # For LocalStack
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack
  
  # S3 force path for LocalStack compatibility
  s3_use_path_style = var.use_localstack
}

module "networking" {
  source = "./modules/networking"
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
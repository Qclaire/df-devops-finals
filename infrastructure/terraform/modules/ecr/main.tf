# modules/ecr/main.tf

resource "aws_ecr_repository" "repo" {
  for_each = toset(var.repository_names)
  
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  for_each = aws_ecr_repository.repo

  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
# modules/ecr/outputs.tf

output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.repo : k => v.repository_url }
}

output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.repo : k => v.arn }
}
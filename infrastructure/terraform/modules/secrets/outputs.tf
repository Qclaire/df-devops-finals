# modules/secrets/outputs.tf

output "secret_arn" {
  description = "ARN of the secret in Secrets Manager"
  value       = aws_secretsmanager_secret.app_secrets.arn
}

output "secret_name" {
  description = "Name of the secret in Secrets Manager"
  value       = aws_secretsmanager_secret.app_secrets.name
}

output "secrets_access_policy_arn" {
  description = "ARN of the IAM policy for accessing secrets"
  value       = aws_iam_policy.secrets_access.arn
}
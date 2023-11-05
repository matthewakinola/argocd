output "ecr_app_url" {
  description = "ECR repo name for app"
  value       = aws_ecr_repository.django_ecr.repository_url
}

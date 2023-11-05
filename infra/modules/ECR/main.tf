resource "aws_ecr_repository" "django_ecr" {
  name                 = "django-k8s-container"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_iam_policy" "allow_ecr_app" {
  name = "read-ecr-app"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        Resource = aws_ecr_repository.django_ecr.arn
      }
    ]
  })
}

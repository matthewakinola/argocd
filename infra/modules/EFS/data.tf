data "aws_secretsmanager_secret_version" "account_creds" {
  secret_id = "django-k8s-creds"
}


locals {
  secret_map = jsondecode(data.aws_secretsmanager_secret_version.account_creds.secret_string)
}
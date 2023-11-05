
#################
#secret manager to handle postgres rds username and password
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "django-k8s-db-creds"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}
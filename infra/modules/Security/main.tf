resource "aws_security_group" "efs_sg" {
  name        = "django-k8s-efs-sg"
  description = "Allow EFS access for EKS cluster."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.efs_subnets
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow EFS access for django-k8s"
  }
}




resource "aws_security_group" "rds_sg" {
  name        = "django-k8s-rds-sg"
  description = "Posgres DB security group."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.database_subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow RDS access for django-k8s"
  }
}
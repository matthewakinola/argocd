
output "efs_sg" {
  value = aws_security_group.efs_sg.id
}


output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

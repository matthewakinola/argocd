output "cluster_name" {
  description = "Name of EKS cluster in AWS."
  value       = aws_eks_cluster.django_eks.name
}

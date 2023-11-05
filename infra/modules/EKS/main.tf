#create EKS cluster
resource "aws_eks_cluster" "django_eks" {
 name = var.cluster_name
 role_arn = aws_iam_role.eks_iam_role.arn

 vpc_config {
  subnet_ids = var.eks_subnet_ids
 }

 depends_on = [
  aws_iam_role.eks_iam_role,
 ]
}

#workers node configuration
resource "aws_eks_node_group" "worker_node_group" {
  cluster_name  = aws_eks_cluster.django_eks.name
  node_group_name = "django-workernodes"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = var.eks_subnet_ids
  disk_size = "20"
  instance_types = ["t3.small"]
 
  scaling_config {
   desired_size = 2
   max_size   = 3
   min_size   = 2
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
 }

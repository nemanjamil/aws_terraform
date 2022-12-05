# EKS cluster
resource "aws_eks_cluster" "runner" {
  name     = var.runner
  role_arn = aws_iam_role.runner.arn
  tags = {
    datadog = "monitored"
  }
  vpc_config {
    subnet_ids = [
      aws_subnet.private-eu-west-2a.id,
      aws_subnet.private-eu-west-2b.id,
      aws_subnet.public-eu-west-2a.id,
      aws_subnet.public-eu-west-2b.id
    ]
  }
  # Dependency of the role policy attachment
  depends_on = [aws_iam_role_policy_attachment.runner-cluster-policy]
}

# Worker nodes with autoscaling

resource "aws_eks_node_group" "runner-workers" {
  cluster_name  = aws_eks_cluster.runner.name
  node_role_arn = aws_iam_role.nodes.arn
  subnet_ids    = [
    aws_subnet.private-eu-west-2a.id,
    aws_subnet.private-eu-west-2b.id
  ]
  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 1
  }
  capacity_type = "ON_DEMAND"
  instance_types = ["m5a.2xlarge"]

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

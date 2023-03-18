# EKS Cluster and Managed Node Group
resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = var.cluster_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks,
  ]
}

resource "aws_eks_node_group" "managing" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "management"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = aws_key_pair.this.key_name
    source_security_group_id = aws_security_group.allow_tls.id
  }

  instance_types = ["t2.medium"]
  ami_type       = "AL2_x86_64"
  subnets        = var.management_subnet_ids

  depends_on = [
    aws_iam_role_policy_attachment.eks,
  ]

  tags = merge(var.common_tags, map(
    "Name", format("%s-managing", aws_eks_cluster.this.name),
  ))
}

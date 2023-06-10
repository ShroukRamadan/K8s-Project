
resource "aws_eks_cluster" "Cluster" {
  name = var.eks-name
  role_arn = aws_iam_role.EKS-cluster-Role.arn

  vpc_config {
    subnet_ids = var.private-subnets-ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs = var.public_access_cidrs
  }
    depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

}


#-----------------------------------------------------------------------------



resource "aws_eks_addon" "kubeproxy-addon" {
  cluster_name = aws_eks_cluster.Cluster.name
  addon_name = "kube-proxy"
}

resource "aws_eks_addon" "coredns-addon" {
  cluster_name = aws_eks_cluster.Cluster.name
  addon_name = "coredns"

}

resource "aws_eks_addon" "vpc-cni-addon" {
  cluster_name = aws_eks_cluster.Cluster.name
  addon_name = "vpc-cni"
}

# resource "aws_launch_template" "launch_template_eks_group_node" {
#   instance_type = "t3.small"
#   # key_name              = "ssh-final-task"
#   block_device_mappings {
#      device_name = "/dev/sda1"
#     ebs {
#       volume_size = 15
#     }
#   }
# }


#---------------------------------------------------------------------------------

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.Cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = var.private-subnets-ids
  
  instance_types = var.instance_types
  
  # launch_template {
  #   id      = aws_launch_template.launch_template_eks_group_node.id
  #   version = "1"
  
  # }


  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key= var.ec2_ssh_key
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


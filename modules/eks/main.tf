# modules/eks/main.tf
variable "cluster_name" { type = string }
variable "node_group_name" { type = string }
variable "node_instance_type" { type = string }

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  vpc_config { subnet_ids = var.subnet_ids }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = [var.node_instance_type]
}

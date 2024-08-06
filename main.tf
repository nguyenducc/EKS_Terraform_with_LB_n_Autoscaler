module "network" {
  source = "./module/network"
  cidr_block_vpc = var.cidr_block_vpc
}

module "eks-cluster" {
  source = "./module/eks"
  all-subnet-ids = module.network.all-sub-net-id
  all-private-subnet_ids = module.network.all-private-subnet-id
}

output "eks_cluster_autoscaler_arn" {
  value = module.eks-cluster.eks_cluster_autoscaler_arn
}
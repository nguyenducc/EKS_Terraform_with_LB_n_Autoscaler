output "url-eks" {
  value = aws_eks_cluster.ducnv-eks-cluster.identity[0].oidc[0].issuer
}

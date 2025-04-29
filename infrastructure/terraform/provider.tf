# provider "aws" {
#   region = "e-west-1"
# }

# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# # data "aws_eks_cluster_auth" "cluster" {
# #   name = module.eks.aws_eks_cluster.eks.name
# # }

# module "eks" {
#   source = "modules/eks"
  
# }
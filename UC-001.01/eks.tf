module "eks" {
 source  = "terraform-aws-modules/eks/aws"
 version = "20.8.4"
 cluster_name    = "my-eks-cluster"
 cluster_version = "1.29"
 vpc_id     = module.vpc.vpc_id
 subnet_ids = module.vpc.private_subnets
 enable_irsa = true
 eks_managed_node_groups = {
   default = {
     instance_types   = ["t2.medium"]
     min_capacity     = 1
     max_capacity     = 2
     desired_capacity = 1
   }
 }
 tags = {
   Environment = "dev"
   Terraform   = "true"
 }
}

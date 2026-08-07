module "vpc" {
  source = "./modules/vpc"

  project_name = local.project_name

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  tags = local.common_tags
}
module "eks" {
  source = "./modules/eks"

  project_name = local.project_name

  kubernetes_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = [
    "t3.medium"
  ]

  node_desired_size = 2
  node_min_size     = 2
  node_max_size     = 3

  tags = local.common_tags

  depends_on = [
    module.vpc
  ]
}
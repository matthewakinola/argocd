

################################################################
# creating VPC
module "VPC" {
  source                              = "./modules/VPC"
  region                              = var.region
  environment                         = var.environment
  prefix                              = "django-k8s"
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}


module "security" {
  source           = "./modules/Security"
  vpc_id           = module.VPC.vpc_id
  efs_subnets      = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  database_subnets = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]

}

module "ECR" {
  source = "./modules/ECR"
}


# Module for Elastic Filesystem; this module will creat elastic file system isn the webservers availablity
# zone and allow traffic fro the webservers

module "EFS" {
  source           = "./modules/EFS"
  efs_subnets      = [
                      module.VPC.private_subnets-3,
                      module.VPC.private_subnets-4
                      ]
  efs_sg           = [module.security.efs_sg]
}

# RDS module; this module will create the RDS instance in the private subnet

module "RDS" {
  source           = "./modules/RDS"
  db_sg            = [module.security.rds_sg]
  db_name          = "django-k8s-postgresdb"
  database_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]
}


module "EKS" {
  source = "./modules/EKS"

  cluster_name = "django-k8s-cluster"
  # vpc_id       = module.VPC.main.id
  eks_subnet_ids  = [module.VPC.private_subnets-1,module.VPC.private_subnets-2]
}


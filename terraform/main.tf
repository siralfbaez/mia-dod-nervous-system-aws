module "kms" {
  source     = "./modules/kms-encryption"
  account_id = data.aws_caller_identity.current.account_id
}

module "iam" {
  source      = "./modules/iam-roles"
  kms_key_arn = module.kms.key_arn
}

module "network" {
  source             = "./modules/vpc-endpoints"
  vpc_id             = var.vpc_id
  aws_region         = var.aws_region
  private_subnet_ids = var.private_subnet_ids
  endpoint_sg_id     = var.endpoint_sg_id
}

module "storage" {
  source      = "./modules/s3-buckets"
  environment = var.environment
  account_id  = data.aws_caller_identity.current.account_id
  kms_key_arn = module.kms.key_arn
}

# Reference to your Aurora Cluster (Simplified for PoC)
module "database" {
  source          = "./modules/rds-aurora"
  kms_key_id      = module.kms.key_arn
  vpc_id          = var.vpc_id
  subnets         = var.private_subnet_ids
}
# export AWS_ACCESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_DEFAULT_REGION="us-west-2"

provider "aws" {
  region = var.region
}

module "vpc" {
  source                    = "./modules/vpc"
  region                    = var.region
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  public_subnet_az          = var.public_subnet_az
  private_subnet_az         = var.private_subnet_az
}

module "instances" {
  source            = "./modules/instances"
  ami               = var.ami
  public_subnet_id  = module.vpc.public_subnet_id
  public_sg         = module.vpc.public_sg
  private_subnet_id = module.vpc.private_subnet_id
  private_sg        = module.vpc.private_sg
  public_key_name   = var.public_key_name
}
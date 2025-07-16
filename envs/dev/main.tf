module "network" {
  source              = "../../modules/network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
}

module "compute" {
  source        = "../../modules/compute"
  env           = var.env
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_ids    = var.subnet_ids
}

module "database" {
  source            = "../../modules/database"
  env               = var.env
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
}

module "eks" {
  source             = "../../modules/eks"
  env                = var.env
  cluster_name       = var.cluster_name
  cluster_role_arn   = var.cluster_role_arn
  node_group_name    = var.node_group_name
  node_role_arn      = var.node_role_arn
  node_instance_type = var.node_instance_type
  subnet_ids         = var.subnet_ids
}

module "security" {
  source                = "../../modules/security"
  env                   = var.env
  cloudtrail_s3_bucket  = var.cloudtrail_s3_bucket
}

module "monitoring" {
  source            = "../../modules/monitoring"
  alarm_definitions = var.alarm_definitions
  ops_sns_topic_arn = var.ops_sns_topic_arn
}
provider "aws" {
  profile                  = var.aws_profile
  shared_credentials_files = var.aws_credentials_path
  region                   = "ap-southeast-2"
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source = "./rds"
  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
  app_security_group_id = module.security_group.app_security_group_id

}

module "security_group" {
  source = "./security_group"
  vpcid = module.vpc.app_vpc_id
}

module "alb" {
  source = "./alb"
  app_security_group_id = module.security_group.app_security_group_id
  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
  vpcid = module.vpc.app_vpc_id
  health_check_path=var.health_check_path
  tf_app_cert_arn = module.acm.tf_app_cert_arn
}

module "ecs" {
  source = "./ecs"
  db_endpoint = module.rds.db_endpoint
  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
  db_port = var.db_port
  db_listen_host = var.db_listen_host
  app_alb_target_group = module.alb.app_alb_target_group
  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
  app_security_group_id = module.security_group.app_security_group_id
}

module "route53" {
  source = "./route53"
  app_alb_zone_id = module.alb.app_alb_zone_id
  app_alb_dns_name = module.alb.app_alb_dns_name
  hosted_zone_domain_name = var.hosted_zone_domain_name
  record_domain_name = var.record_domain_name
}

module "acm" {
  source = "./acm"
  hosted_zone_domain_name = var.hosted_zone_domain_name
  record_domain_name = var.record_domain_name
  }
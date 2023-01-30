

/*
*
*  SSM parameters
* 
*/
data "aws_ssm_parameter" "sg12_database_user" {
  name            = "SG12-DB-USER"
  with_decryption = true
}

data "aws_ssm_parameter" "sg12_database_password" {
  name            = "SG12-DB-PASS"
  with_decryption = true
}

data "aws_ssm_parameter" "sg12_database_root_password" {
  name            = "SG12-DB-ROOT-PASS"
  with_decryption = true
}


/*
*
* Network Module: VPC, Subnets, Route tables
* 
*/
module "network" {
  source   = "../modules/network"
  APP_NAME = var.APP_NAME
  ENV      = var.ENV
  VPC-CIDR = var.VPC-CIDR

  VPC-PUB-A-CIDR = var.VPC-PUB-A-CIDR
  VPC-PUB-B-CIDR = var.VPC-PUB-B-CIDR
  VPC-PUB-C-CIDR = var.VPC-PUB-C-CIDR

  VPC-APP-A-CIDR = var.VPC-APP-A-CIDR
  VPC-APP-B-CIDR = var.VPC-APP-B-CIDR
  VPC-APP-C-CIDR = var.VPC-APP-C-CIDR

  VPC-DB-A-CIDR = var.VPC-DB-A-CIDR
  VPC-DB-B-CIDR = var.VPC-DB-B-CIDR
  VPC-DB-C-CIDR = var.VPC-DB-C-CIDR
}

/*
*
* Security Module: Security Grupups , Instance profile
* 
*/
module "security" {
  source   = "../modules/security"
  VPC_ID   = module.network.vpc_id
  APP_NAME = var.APP_NAME
  ENV      = var.ENV
}


/*
*
* Database Module: Mysql RDS
* 
*/

module "database" {
  source           = "../modules/database"
  VPC_ID           = module.network.vpc_id
  DB_USERNAME      = data.aws_ssm_parameter.sg12_database_user.value
  DB_ROOT_PASSWORD = data.aws_ssm_parameter.sg12_database_root_password.value
  DB_PASSWORD      = data.aws_ssm_parameter.sg12_database_password.value
  VPC_DB_SUBNET    = module.network.vpc_subnet_group_database.id
  SG_MYSQL         = module.security.SG_Allow_Mysql.id
  ALB_DNS          = module.load-balancer.sg12_alb_dns
}



/*
*
* Compute Module: Security Grupups , Instance profile
* 
*/
module "compute" {
  source               = "../modules/compute"
  VPC_ID               = module.network.vpc_id
  APP_NAME             = var.APP_NAME
  ENV                  = var.ENV
  EC2_WP_AMI           = var.EC2_WP_AMI
  EC2_TYPE             = var.EC2_TYPE
  SG                   = module.security.SG_Allow_Wordpress.id
  EC2_PROFILE          = module.security.ec2_instance_profile
  DB_PASSWORD          = data.aws_ssm_parameter.sg12_database_password.value
  DB_USERNAME          = data.aws_ssm_parameter.sg12_database_user.value
  DB_HOST              = module.database.sg12_database_address
  EFS_ID               = module.storage.sg12_efs_id
  PUBLIC_SUB_A         = module.network.vpc_subnet_pub_A.id
  PUBLIC_SUB_B         = module.network.vpc_subnet_pub_B.id
  PUBLIC_SUB_C         = module.network.vpc_subnet_pub_C.id
  LOAD_BALANCER_ARN    = module.load-balancer.sg12_alb_arn
  LOAD_BALANCER_TG_ARN = module.load-balancer.sg12_alb_tg_arn
  ASG_DESIRED          = var.ASG_DESIRED
  ASG_MAX_SIZE         = var.ASG_MAX_SIZE
  ASG_MIN_SIZE         = var.ASG_MIN_SIZE
}



/*
*
* Storage Module - EFS
* 
*/

module "storage" {
  source           = "../modules/storage"
  SG_EFS           = module.security.SG_Allow_EFS.id
  SG_EC2           = module.security.SG_Allow_Wordpress.id
  EFS_APP_SUB_A    = module.network.vpc_subnet_app_A.id
  EFS_APP_SUB_B    = module.network.vpc_subnet_app_B.id
  EFS_App_SUB_C    = module.network.vpc_subnet_app_C.id
  ENV              = var.ENV
}






/*
*
* AutoScaling Module - Application Load Balancer,Target Grpup
* 
*/

module "load-balancer" {
  source       = "../modules/load-balancer"
  PUBLIC_SUB_A = module.network.vpc_subnet_pub_A.id
  PUBLIC_SUB_B = module.network.vpc_subnet_pub_B.id
  PUBLIC_SUB_C = module.network.vpc_subnet_pub_C.id
  SG           = module.security.SG_Allow_ELB.id
  VPC_ID       = module.network.vpc_id
  ENV          = var.ENV
}
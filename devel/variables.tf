variable "AWS_REGION" {
  default     = "us-east-1"
  description = "aws region"
}

variable "APP_NAME" {
  default     = "SG12 WordPress Devel"
  description = "application name"
}

variable "ENV" {
  default     = "devel"
  description = "enviroment"
}

variable "TF_CLOUD_ORGANIZATION" {
  default     = "curlycloud"
  description = "AWS_SECRET_ACCESS_KEY"
}
  
variable "TF_CLOUD_WORKSPACE" {
  default     = "sg12-wordpress-terraform-devel"
  description = "AWS_SECRET_ACCESS_KEY"
}

variable "AWS_DEPLOY_ROLE" {
  default     = "replace with your role ARN"
  description = "AWS role with the rights to deploy the infrascture"
}

variable "AWS_SECRET_ACCESS_KEY" {
  default     = "AWS_SECRET_ACCESS_KEY"
  description = "need to setup this in terraform cloud workspace"
}

variable "AWS_ACCESS_KEY_ID" {
  default     = "AWS_ACCESS_KEY_ID"
  description = "need to setup this in terraform cloud workspace"
}

/*
*
* CIDR for VPC and subnets
*
*/


variable "VPC-CIDR" {
  default     = "10.16.0.0/16"
  description = "VPC cidr"
}

variable "VPC-PUB-A-CIDR" {
  default     = "10.16.48.0/20"
  description = "public subnet A cidr"
}

variable "VPC-PUB-B-CIDR" {
  default     = "10.16.112.0/20"
  description = "public subnet B cidr"
}

variable "VPC-PUB-C-CIDR" {
  default     = "10.16.176.0/20"
  description = "public subnet C cidr"
}

variable "VPC-APP-A-CIDR" {
  default     = "10.16.32.0/20"
  description = "application subnet A cidr"
}

variable "VPC-APP-B-CIDR" {
  default     = "10.16.96.0/20"
  description = "application subnet B cidr"
}

variable "VPC-APP-C-CIDR" {
  default     = "10.16.160.0/20"
  description = "application subnet C cidr"
}

variable "VPC-DB-A-CIDR" {
  default     = "10.16.16.0/20"
  description = "database subnet A cidr"
}

variable "VPC-DB-B-CIDR" {
  default     = "10.16.80.0/20"
  description = "database subnet B cidr"
}

variable "VPC-DB-C-CIDR" {
  default     = "10.16.144.0/20"
  description = "database subnet C cidr"
}

/*
*
* AMI FOR EC2
*
*/
variable "EC2_WP_AMI" {
  default     = "replace with your AMI"
  description = "SG12 Custom Wordpress Image"
}

variable "EC2_TYPE" {
  default     = "t2.micro"
  description = "SG12 devel instance type"
}

/*
*
* Autoscaling Group values
*
*/
variable "ASG_DESIRED"{
  default     = 1
  description = "ASG Desired capacity"
}
variable "ASG_MAX_SIZE"{
  default     = 1
  description = "ASG Max capacity"
}
variable "ASG_MIN_SIZE"{
  default     = 1
  description = "ASG Min capacity"
}
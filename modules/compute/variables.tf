variable "VPC_ID" {
  type        = string
  description = "vpc id - output of network module "
}
variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "SG" {
  type = string
}
variable "EC2_WP_AMI" {
  type = string
}
variable "EC2_TYPE" {
  type = string
}

variable "EC2_PROFILE" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_USERNAME" {
  type = string
}

variable "DB_HOST" {
  type = string
}
variable "EFS_ID" {
  type = string
}
variable "PUBLIC_SUB_A" {
  type = string
}

variable "PUBLIC_SUB_B" {
  type = string
}

variable "PUBLIC_SUB_C" {
  type = string
}

variable "LOAD_BALANCER_ARN" {
  type = string
}

variable "LOAD_BALANCER_TG_ARN"{
  type= string
}

variable "ASG_DESIRED"{
  type= string
}
variable "ASG_MAX_SIZE"{
  type= string
}
variable "ASG_MIN_SIZE"{
  type= string
}
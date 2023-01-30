variable "DB_USERNAME" {
  type = string
}
variable "DB_ROOT_PASSWORD" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "VPC_DB_SUBNET"{
  type = string
}
variable "SG_MYSQL"{
  type = string
}
variable "ALB_DNS"{
  type = string
}
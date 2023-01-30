resource "aws_db_instance" "wordpress_database" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = var.VPC_DB_SUBNET
  vpc_security_group_ids = [var.SG_MYSQL]
}

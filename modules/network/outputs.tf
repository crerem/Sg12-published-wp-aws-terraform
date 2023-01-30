output "vpc_id" {
  value = aws_vpc.WordpressTerraformVpc.id
}

output "vpc_subnet_pub_A" {
  value = aws_subnet.Public_Subnet_A_WordpressTerraform
}
output "vpc_subnet_pub_B" {
  value = aws_subnet.Public_Subnet_B_WordpressTerraform
}
output "vpc_subnet_pub_C" {
  value = aws_subnet.Public_Subnet_C_WordpressTerraform
}

output "vpc_subnet_group_database" {
  value = aws_db_subnet_group.aws_db_subnet_group_for_database
}


output "vpc_subnet_app_A" {
  value = aws_subnet.Application_Subnet_A_WordpressTerraform
}
output "vpc_subnet_app_B" {
  value = aws_subnet.Application_Subnet_B_WordpressTerraform
}
output "vpc_subnet_app_C" {
  value = aws_subnet.Application_Subnet_C_WordpressTerraform
}

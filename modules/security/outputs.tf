output "SG_Allow_Wordpress" {
  value = aws_security_group.SG_Allow_Wordpress
}

output "ec2_instance_profile" {
  value = aws_iam_instance_profile.Instance_Profile_Wordpress_Role.arn
}

output "SG_Allow_Mysql" {
   value = aws_security_group.SG_Allow_Mysql
}

output "SG_Allow_EFS" {
  value = aws_security_group.SG_Allow_EFS
}

output "SG_Allow_ELB" {
  value = aws_security_group.SG_Allow_ELB
}

/*
*
* security group for elastic load balancer
*
*/

resource "aws_security_group" "SG_Allow_ELB" {

  description = "Control acces to load balancer ${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description = "Allow ELB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  ingress {
    description = "Allow https ipv4"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "${var.APP_NAME}_allow_ELB_${var.ENV}"
  }
}


/*
*
* security group for Wordpress instances
*
*/
resource "aws_security_group" "SG_Allow_Wordpress" {

  description = "Control access to Wordpress Instances ${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description = "Allow http from ELB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.SG_Allow_ELB.id]
  }  
 
  ingress {
    description = "Allow https ipv4"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
      security_groups = [aws_security_group.SG_Allow_ELB.id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  


  tags = {
    "Name" = "${var.APP_NAME}_allow_WP"
  }
}


/*
*
* security group for Mysql
*
*/

resource "aws_security_group" "SG_Allow_Mysql" {

  description = "Control acces to database ${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "Allow mysql in via 3306 from Wordpress SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.SG_Allow_Wordpress.id]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.APP_NAME}_allow_DB"
  }
}



/*
*
* security group for EFS
*
*/
resource "aws_security_group" "SG_Allow_EFS" {

  description = "Control acces to elastic file system ${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "Allow efs"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.SG_Allow_Wordpress.id]
 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.APP_NAME}_allow_EFS"
  }
}


/*
*
* Roles
*
*/
resource "aws_iam_role" "Wordpress_Role" {
  name = "wordpress_role_${var.ENV}"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"]
}


/*
*
* Ec2 Instance profile
*
*/
resource "aws_iam_instance_profile" "Instance_Profile_Wordpress_Role" {
  name = "instance_profile_${var.ENV}"
  role = aws_iam_role.Wordpress_Role.name
}
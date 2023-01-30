
// declare the availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

/*
* define the vpc
*
*/
resource "aws_vpc" "WordpressTerraformVpc" {

  tags = {
    "Name" = "${var.APP_NAME}_${var.ENV}"
  }
  cidr_block           = var.VPC-CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true

}

/*
*
* define the internet gateway
*
*/

resource "aws_internet_gateway" "IgWordpressTerraform" {
  tags = {
    "Name" = "Internet Gateway for SG12 Wordpress Terraform ${var.ENV}"
  }
  vpc_id = aws_vpc.WordpressTerraformVpc.id
}





/*
*
* route tables
*
*/


resource "aws_route_table" "Route_Table_WordpressTerraformVpc" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_main_route_table_${var.ENV}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IgWordpressTerraform.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.IgWordpressTerraform.id
  }

}

/*
*
* create public layer subnets  
*
*/


resource "aws_subnet" "Public_Subnet_A_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_public_A_${var.ENV}"
  }
  cidr_block              = var.VPC-PUB-A-CIDR
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Public_Subnet_B_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
   "Name" = "${var.APP_NAME}_public_B_${var.ENV}"
  }
  cidr_block              = var.VPC-PUB-B-CIDR
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Public_Subnet_C_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_public_C_${var.ENV}"
  }
  cidr_block              = var.VPC-PUB-C-CIDR
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
}

locals {
  subnet_public_ids = [aws_subnet.Public_Subnet_A_WordpressTerraform.id,aws_subnet.Public_Subnet_B_WordpressTerraform.id, aws_subnet.Public_Subnet_C_WordpressTerraform.id, ]
}






/*
*
* create application layer subnets  
*
*/


resource "aws_subnet" "Application_Subnet_A_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_application_A_${var.ENV}"
  }
  cidr_block        =  var.VPC-APP-A-CIDR
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "Application_Subnet_B_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
  "Name" = "${var.APP_NAME}_application_B_${var.ENV}"
  }
  cidr_block        =  var.VPC-APP-B-CIDR
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "Application_Subnet_C_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_application_C_${var.ENV}"
  }
  cidr_block        =  var.VPC-APP-C-CIDR
  availability_zone = data.aws_availability_zones.available.names[2]
}







/*
*
* create database layer subnets  
*
*/


resource "aws_subnet" "Database_Subnet_A_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_database_A_${var.ENV}"
  }
  cidr_block        =  var.VPC-DB-A-CIDR
  availability_zone = data.aws_availability_zones.available.names[0]

}

resource "aws_subnet" "Database_Subnet_B_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_database_B_${var.ENV}"
  }
  cidr_block        = var.VPC-DB-B-CIDR
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "database_Subnet_C_WordpressTerraform" {
  vpc_id = aws_vpc.WordpressTerraformVpc.id
  tags = {
    "Name" = "${var.APP_NAME}_database_C_${var.ENV}"
  }
  cidr_block        = var.VPC-DB-C-CIDR
  availability_zone = data.aws_availability_zones.available.names[2]
}

resource "aws_db_subnet_group" "aws_db_subnet_group_for_database" {
  name = "subnet_database_${var.ENV}"
  subnet_ids = [aws_subnet.Database_Subnet_A_WordpressTerraform.id,aws_subnet.Database_Subnet_B_WordpressTerraform.id, aws_subnet.database_Subnet_C_WordpressTerraform.id, ]

  tags = {
    Name = "My DB subnet group"
  }
}



/*
*
* associate public subnets with route table
*
*/

resource "aws_route_table_association" "association_pub_a" {
  subnet_id      = aws_subnet.Public_Subnet_A_WordpressTerraform.id
  route_table_id = aws_route_table.Route_Table_WordpressTerraformVpc.id
}

resource "aws_route_table_association" "association_pub_b" {
  subnet_id      = aws_subnet.Public_Subnet_B_WordpressTerraform.id
  route_table_id = aws_route_table.Route_Table_WordpressTerraformVpc.id
}

resource "aws_route_table_association" "association_pub_c" {
  subnet_id      = aws_subnet.Public_Subnet_C_WordpressTerraform.id
  route_table_id = aws_route_table.Route_Table_WordpressTerraformVpc.id
}

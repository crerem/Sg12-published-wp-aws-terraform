resource "aws_efs_file_system" "efs" {
  creation_token = "sg12-efs-${var.ENV}"
  tags = {
    Name = "EFS-sg12-${var.ENV}"
  }
}

resource "aws_efs_mount_target" "mount_subnet_public_A" {
    file_system_id  = aws_efs_file_system.efs.id
    subnet_id       = var.EFS_APP_SUB_A
    security_groups = ["${var.SG_EC2}"]
}

resource "aws_efs_mount_target" "mount_subnet_public_B" {
    file_system_id  = aws_efs_file_system.efs.id
    subnet_id       = var.EFS_APP_SUB_B
    security_groups = ["${var.SG_EC2}"]
}
resource "aws_efs_mount_target" "mount_subnet_public_C" {
    file_system_id  = aws_efs_file_system.efs.id
    subnet_id       = var.EFS_App_SUB_C
    security_groups = ["${var.SG_EC2}"]
}
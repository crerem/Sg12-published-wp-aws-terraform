
/*
* Create a Launch Configuration
*/

resource "aws_launch_configuration" "SG12-WP-Lunch-Template" {
  name_prefix                 ="sg12-aws-asg-${var.ENV}"
  image_id                    = var.EC2_WP_AMI
  instance_type               = var.EC2_TYPE
  security_groups             = ["${var.SG}"]
  iam_instance_profile        = var.EC2_PROFILE
  associate_public_ip_address = true
  enable_monitoring           = false
  lifecycle {
    create_before_destroy = true
  }
  user_data=<<EOF
#!/bin/bash
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/'localhost'/'${var.DB_HOST}'/g" /var/www/html/wp-config.php
sudo sed -i "s/'database_name_here'/'mydb'/g" /var/www/html/wp-config.php
sudo sed -i "s/'username_here'/'${var.DB_USERNAME}'/g" /var/www/html/wp-config.php
sudo sed -i "s/'password_here'/'${var.DB_PASSWORD}'/g" /var/www/html/wp-config.php



echo -e "${var.EFS_ID}:/ /var/www/html/wp-content efs _netdev,tls,iam 0 0" >> /etc/fstab
mount -a -t efs defaults
chown -R ec2-user:apache /var/www/
mkdir /var/www/html/wp-content/plugins
mkdir /var/www/html/wp-content/themes
sudo chown -R apache:apache /var/www/html/
EOF

}





/*
* Create a Autoscaling Group
*/
resource "aws_autoscaling_group" "SG12-Autoscaling-Group" {

  desired_capacity    = var.ASG_DESIRED
  max_size            = var.ASG_MAX_SIZE
  min_size            = var.ASG_MIN_SIZE
  vpc_zone_identifier = [var.PUBLIC_SUB_A, var.PUBLIC_SUB_B, var.PUBLIC_SUB_C]
  health_check_type   = "ELB"

  launch_configuration=aws_launch_configuration.SG12-WP-Lunch-Template.name
  tag {
    key                 = "Name"
    value               = "Sg12-SG-${var.ENV}"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}


/*
*
* Attach autoscaling group to ELB
*
*/

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.SG12-Autoscaling-Group.id
  lb_target_group_arn                    = var.LOAD_BALANCER_TG_ARN
}


/*
*
* Create autoscaling grpup policy
*
*/


resource "aws_autoscaling_policy" "sg12_autoscale" {
  name                   = "SG12-Autoscaling-Group-Policy-${var.ENV}"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.SG12-Autoscaling-Group.name
}


/*
*
* Create cloudwatch metric for autoscaling policy
*
*/

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for Sg12 ASG ${var.ENV}"
  alarm_actions       = [aws_autoscaling_policy.sg12_autoscale.arn]
  alarm_name          = "sg12 scale ${var.ENV}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "60"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.SG12-Autoscaling-Group.name
  }
}

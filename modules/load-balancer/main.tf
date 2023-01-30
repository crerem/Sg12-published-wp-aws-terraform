//create the application load balancer
resource "aws_lb" "sg12_alb" {
  name               =  "SG12-APP-Load-Balancer-${var.ENV}"
  internal           =  false
  load_balancer_type =  "application"
  ip_address_type    =  "ipv4"
  security_groups    =  [var.SG]
  subnets            =  [var.PUBLIC_SUB_A,var.PUBLIC_SUB_B,var.PUBLIC_SUB_C]

  enable_deletion_protection = false
  tags = {
    Environment = "ELB SG12 ${var.ENV}"
  }
}

/*
* create the application load balancer listner
*/

resource "aws_lb_listener" "sg12_alb_listener" {
  load_balancer_arn = aws_lb.sg12_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sg12_alb_target_group.arn
  }
}




/*
* create the application load balancer  target group
*/

resource "aws_lb_target_group" "sg12_alb_target_group" {
  name     = "sg12-alb-target-group-${var.ENV}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID
  health_check {
  
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}
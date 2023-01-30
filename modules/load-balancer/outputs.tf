output "sg12_alb_arn" {
  value = aws_lb.sg12_alb.arn
}

output "sg12_alb_dns" {
  value = aws_lb.sg12_alb.dns_name
}

output "sg12_alb_tg_arn" {
  value= aws_lb_target_group.sg12_alb_target_group.arn
}
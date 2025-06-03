output "alb_arn" {
  value = module.alb.id
}

output "target_id" {
  value = aws_lb_target_group.test-target-group.id
}

output "arn" {
  value = module.alb.arn
}
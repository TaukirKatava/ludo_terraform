resource "aws_lb_target_group" "tg" {
  for_each = var.instance_data
  name     = "${replace(each.key, "_", "-")}-tg"
  port     = 3000
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id
  deregistration_delay = 180
  health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
  }
}

# resource "aws_lb_target_group_attachment" "tg-ec2-attachments" {
#   for_each = var.instance_ids
#   target_group_arn = aws_lb_target_group.tg[each.key].arn
#   target_id        = "${each.value}"
#   port             = 3000
# }

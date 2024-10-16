output "tg-arn" {
  value = tomap({
    for tg_name, tg_arn in aws_lb_target_group.tg : tg_name => tg_arn.arn
  })
}
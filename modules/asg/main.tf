resource "aws_autoscaling_group" "asg" {
  for_each = var.launch_template_id
  name = "${each.key}-asg"
  vpc_zone_identifier = [ var.private-subnet-1a-id, var.private-subnet-1b-id ]
  # default_instance_warmup = 180
  launch_template {
    id      = each.value
    version = var.lt_latest_version[each.key]
  }

  desired_capacity   = var.instance_count[each.key]
  max_size           = 5
  min_size           = var.instance_count[each.key] 
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      skip_matching = true
    }
    triggers = ["launch_template"]
  }
  lifecycle {
    ignore_changes = [ desired_capacity ]
  }
}

resource "aws_autoscaling_policy" "asg_target_tracking_policy" {
    for_each = var.launch_template_id
    name = "${each.key}-autoscaling-policy"
    policy_type = "TargetTrackingScaling"
    autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
    estimated_instance_warmup = 60

    target_tracking_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        }

            target_value = "60"

        }
}

resource "time_sleep" "wait_for_asg" {
  create_duration = "300s"
  depends_on = [ aws_autoscaling_group.asg ]
  
}

resource "aws_autoscaling_attachment" "asg_tg_attachment" {
  for_each = var.tg-arn
  autoscaling_group_name = aws_autoscaling_group.asg[each.key].name
  lb_target_group_arn    = each.value
  depends_on = [ time_sleep.wait_for_asg ]
}
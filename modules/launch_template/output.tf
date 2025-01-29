output "launch_template_arn" {
    value = tomap(
        {
            for v, k in aws_launch_template.lt : v => k.arn
        }
    )
}

output "launch_template_id" {
    value = tomap(
        {
            for v, k in aws_launch_template.lt : v => k.id
        }
    )
}

output "launch_template_latest_version" {
    value = tomap(
        {
            for v, k in aws_launch_template.lt : v => k.latest_version
        }
    )
}


output "tg-arn" {
  value = module.tg.tg-arn
}

# output "instance_ids" {
#   value = module.ec2-instance.instance_ids
# }

# output "ami_ids" {
#   value = module.ami.ami_ids
# }

output "launch_template_arn" {
  value = module.launch_template.launch_template_arn
}

output "launch_template_latest_version" {
    value = module.launch_template.launch_template_latest_version
}
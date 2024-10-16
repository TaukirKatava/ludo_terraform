output "instance_ids" {
  value = tomap({
    for instance_names, instance_ids in aws_instance.ec2 : instance_names => instance_ids.id
  })
}

output "ec2_sg_id" {
  value = aws_security_group.sg.id
  
}
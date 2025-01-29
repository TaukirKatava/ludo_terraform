output "ami_ids" {
    value = tomap(
        {
            for k, v in aws_ami_from_instance.instance-amis : k  => v.id
        }
     )
  
}
resource "aws_launch_template" "lt" {
    for_each = var.instance_data
    name = "${each.key}-lt"
    image_id = var.ubuntu_ami
    instance_type = var.instance_data[each.key]
    key_name = var.pem_file
    vpc_security_group_ids = [ var.ec2_sg_id ]
    #update_default_version = true  #Not needed
    description = "This Launch Template is used for ${each.key} mode"
    user_data = "${base64encode(file("./stag_scripts/stag_${each.key}.sh"))}"

    tag_specifications {
    resource_type = "instance"

        tags = {
            Name = "${each.key}-lt"
            "ManagedBy" = "Yudiz"
            "Terraform" = "Yes"
            "Mode" = "${each.key}"
        }  
    }

    tag_specifications {
    resource_type = "volume"

        tags = {
            Name = "${each.key}-lt"
            "ManagedBy" = "Yudiz"
            "Terraform" = "Yes"
            "Mode" = "${each.key}"
        }  
    }

    iam_instance_profile {
        name = var.iam_instance_profile_name
    }

    block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = var.volume_size
      delete_on_termination = true
      volume_type           = var.volume_type
    }
    }

    lifecycle {
      ignore_changes = [ user_data ]
    }
}
resource "aws_ami_from_instance" "instance-amis" {
    for_each = var.instance_ids
    # name = "${each.key}-AMI-${formatdate("DDMMYYYY", timestamp())}"
    name = "${each.key}-AMI-"
    source_instance_id = each.value
    snapshot_without_reboot = true

    tags = {
      # "Name" = "${each.key}-AMI-${formatdate("DDMMYYYY", timestamp())}"
      "Name" = "${each.key}-AMI"
      "ManagedBy" = "Yudiz"
      "Terraform" = "Yes"
      "Mode" = "${each.key}"
    }
    # provisioner "local-exec" {
    #   command = "terraform destroy --target"
      
    # }
}
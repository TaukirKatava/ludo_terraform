data "aws_ami" "myami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

#create security group 
resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = var.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "server-sg-${var.project_name}"
    "ManagedBy" = "Yudiz"
    "Terraform" = "yes"
    "Mode" = "common"
  }
}


resource "aws_instance" "ec2" {
  ami = data.aws_ami.myami.id
  for_each = var.instance_data
  instance_type = each.value
  subnet_id = var.private-subnet-1a-id
  key_name = var.pem_file
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  iam_instance_profile = var.iam_instance_profile_name
  tags = {
    "Name" = "${each.key}-${var.project_name}-prod"
    "terraform" = "yes"
    "Mode" = "${each.key}"
    "ManagedBy" = "Yudiz"
  }
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }

  depends_on = [ aws_security_group.sg ]
  user_data = "${file("./stag_scripts/stag_${each.key}.sh")}"

  lifecycle {
    ignore_changes = [ user_data ]
  }
}
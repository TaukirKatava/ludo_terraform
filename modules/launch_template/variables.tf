# variable "ami_ids" {
#     type = map(string)
  
# }

variable "instance_data" {
    type = map
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "iam_instance_profile_name" {
    type = string
  
}

variable "pem_file" {
    type = string
}

variable "ec2_sg_id" {
    type = string
  
}

variable "ubuntu_ami" {
    type = string
  
}
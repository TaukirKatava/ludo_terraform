variable "project_name" {
  type = string
}

variable "instance_data" {
    type = map  
}

variable "my-ip" {
  type = string  
}

variable "vpc_id" {
  type = string
}

# variable "public-subnet-1a-id" {
#     type = string
# }

variable "pem_file" {
  type = string
  
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

variable "private-subnet-1a-id" {
    type = string
}

variable "private-subnet-1b-id" {
    type = string
}
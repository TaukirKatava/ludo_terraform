variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_data" {
  type = map(any)
}

variable "my-ip" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public-subnet-1a-cidr-block" {
  type = string
}

variable "public-subnet-1b-cidr-block" {
  type = string
}

variable "public-subnet-1c-cidr-block" {
  type = string
}

variable "private-subnet-1a-cidr-block" {
  type = string
}

variable "private-subnet-1b-cidr-block" {
  type = string
}

variable "subnet_az1a" {
  type = string
}

variable "subnet_az1b" {
  type = string
}

variable "subnet_az1c" {
  type = string
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = number
}

# variable "instance_ids" {
#     type = map
# }

variable "health_check" {
  type = map(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "instance_count" {
  type = map(any)

}
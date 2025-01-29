variable "vpc_id" {
    type = string
}

variable "project_name" {
  type = string
}

variable "public-subnet-1a-id" {
    type = string
}

variable "public-subnet-1b-id" {
    type = string
}

variable "public-subnet-1c-id" {
    type = string
}

variable "acm_certificate_arn" {
    type = string
}

variable "tg_arn" {
    type = map(string)
  
}
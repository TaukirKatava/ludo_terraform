variable "vpc_id" {
    type = string
  
}
variable "instance_ids" {
    type = map(string)
}

variable "health_check" {
    type = map(string)
}
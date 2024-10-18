variable "launch_template_id" {
    type = map(string)
}

variable "private-subnet-1a-id" {
    type = string
}

variable "private-subnet-1b-id" {
    type = string
}

variable "instance_count" {
    type = map
}

variable "tg-arn" {
    type = map
}

variable "lt_latest_version" {
  type = map
}

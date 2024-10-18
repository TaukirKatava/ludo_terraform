region                       = "us-east-1"
profile                      = "aaqib_aws"
project_name                 = "ludo-naresh"
my-ip                        = "103.156.142.125/32"
vpc_cidr_block               = "10.0.0.0/16"
public-subnet-1a-cidr-block  = "10.0.1.0/24"
public-subnet-1b-cidr-block  = "10.0.2.0/24"
public-subnet-1c-cidr-block  = "10.0.3.0/24"
private-subnet-1a-cidr-block = "10.0.4.0/24"
private-subnet-1b-cidr-block = "10.0.5.0/24"
subnet_az1a                  = "us-east-1a"
subnet_az1b                  = "us-east-1b"
subnet_az1c                  = "us-east-1c"
instance_data = {
  "classic_auto"   = "t2.micro"
  "classic_manual" = "t2.micro"
  "quick"          = "t2.micro"
  "multiplayer"    = "t2.micro"
  # "demo"          = "t2.micro"
}
volume_size = 30
volume_type = "gp3"
health_check = {
  "timeout"             = "10"
  "interval"            = "30"
  "path"                = "/ping"
  "port"                = "traffic-port"
  "unhealthy_threshold" = "2"
  "healthy_threshold"   = "3"
}
acm_certificate_arn = "arn:aws:acm:us-east-1:590183687498:certificate/b45428e6-fe52-422c-a863-0acd53cffd97"
instance_count = {
  "classic_manual" = 1
  "classic_auto"   = 1
  "quick"          = 1
  "multiplayer"    = 1
  # "demo"  =1
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

module "vpc" {
  source                       = "./modules/vpc"
  vpc_cidr_block               = var.vpc_cidr_block
  public-subnet-1a-cidr-block  = var.public-subnet-1a-cidr-block
  public-subnet-1b-cidr-block  = var.public-subnet-1b-cidr-block
  public-subnet-1c-cidr-block  = var.public-subnet-1c-cidr-block
  private-subnet-1a-cidr-block = var.private-subnet-1a-cidr-block
  private-subnet-1b-cidr-block = var.private-subnet-1b-cidr-block
  subnet_az1a                  = var.subnet_az1a
  subnet_az1b                  = var.subnet_az1b
  subnet_az1c                  = var.subnet_az1c
  project_name                 = var.project_name
}


module "pem_file" {
  source = "./modules/pem_file"
}


module "ec2-instance" {
  source                    = "./modules/ec2"
  instance_data             = var.instance_data
  project_name              = var.project_name
  my-ip                     = var.my-ip
  vpc_id                    = module.vpc.vpc_id
  pem_file                  = module.pem_file.pem_file
  volume_size               = var.volume_size
  volume_type               = var.volume_type
  iam_instance_profile_name = module.iam.iam_role_name
  private-subnet-1a-id      = module.vpc.private-subnet-1a-id
  private-subnet-1b-id      = module.vpc.private-subnet-1b-id
  depends_on = [ module.vpc ]
}

resource "time_sleep" "wait_for_instances" {
  depends_on = [module.ec2-instance]
  # Wait time set to 600 seconds (10 minutes)
  create_duration = "600s"
}

module "ami" {
  source       = "./modules/ami"
  instance_ids = module.ec2-instance.instance_ids
  depends_on   = [time_sleep.wait_for_instances]
}
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "alb" {
  source              = "./modules/alb"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public-subnet-1a-id = module.vpc.public-subnet-1a-id
  public-subnet-1b-id = module.vpc.public-subnet-1b-id
  public-subnet-1c-id = module.vpc.public-subnet-1c-id
  acm_certificate_arn = var.acm_certificate_arn
  tg_arn              = module.tg.tg-arn
  #depends_on = [ module.vpc, module.ec2-instance ]
}

module "tg" {
  source       = "./modules/tg"
  instance_ids = module.ec2-instance.instance_ids
  health_check = var.health_check
  vpc_id       = module.vpc.vpc_id
  #depends_on = [ module.ec2-instance ]
}

module "launch_template" {
  source                    = "./modules/launch_template"
  instance_data             = var.instance_data
  ami_ids                   = module.ami.ami_ids
  volume_size               = var.volume_size
  volume_type               = var.volume_type
  iam_instance_profile_name = module.iam.iam_instance_profile_name
  ec2_sg_id                 = module.ec2-instance.ec2_sg_id
  pem_file                  = module.pem_file.pem_file
  #depends_on = [ module.ec2-instance, module.ami ]
}

module "asg" {
  source               = "./modules/asg"
  launch_template_id   = module.launch_template.launch_template_id
  private-subnet-1a-id = module.vpc.private-subnet-1a-id
  private-subnet-1b-id = module.vpc.private-subnet-1b-id
  instance_count       = var.instance_count
  tg-arn               = module.tg.tg-arn
  #depends_on = [ module.tg ]
  # lt_latest_version = module.launch_template.launch_template_latest_version

}


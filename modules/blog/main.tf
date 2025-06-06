data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_tomcat_info.server_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_tomcat_info.virtualization_type]
  }

  owners = [var.ami_tomcat_info.owner]
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.3.0"
  # insert the 1 required variable here

  name = var.app_name

  min_size = var.min_size_slg
  max_size = var.max_size_slg

  vpc_zone_identifier = module.blog_vpc.public_subnets
  
  traffic_source_attachments = {
    traffic_source = {
      type = "elbv2"
      traffic_source_identifier = module.blog_alb.target_groups.ex-instance.arn
  }
}

  security_groups = [module.blog_sg.security_group_id]

  image_id               = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
}

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.environment.name
  cidr = "${var.environment.network_prefix}0.0/16"

  azs             = var.eu_azs
  public_subnets  = ["${var.environment.network_prefix}101.0/24", "${var.environment.network_prefix}102.0/24", "${var.environment.network_prefix}103.0/24"]

  tags = {
    Terraform = "true"
    Environment = var.environment.name
  }
}

module "blog_alb" {
  source = "terraform-aws-modules/alb/aws"

  name   = "${var.app_name}-alb"

  vpc_id          = module.blog_vpc.vpc_id
  subnets         = module.blog_vpc.public_subnets
  security_groups = [module.blog_sg.security_group_id]

  target_groups = {
    ex-instance = {
      name_prefix      = "${var.app_name}-"
      protocol         = "HTTP"
      port             = 80
      target_type      = "instance"
      create_attachment = false
    }
  }

  listeners = {
    http = {
      port               = 80
      protocol           = "HTTP"
      
      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  tags = {
    Environment = var.environment.name
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name    = "${var.app_name}_new"

  vpc_id              = module.blog_vpc.vpc_id

  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]

  # Prevent IPv6 rule created by default by the module
  egress_ipv6_cidr_blocks = []
}

variable "app_name" {
  description = "The application name to use in AWS' resources"

  default = "blog"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.micro"
}

variable "ami_tomcat_info" {
  description           = "The filter information required for a tomcat server, for the AMI"

  type = object ({
    server_name         = string
    owner               = string
    virtualization_type = string
  })

  default = {
    server_name              = "bitnami-tomcat-*-x86_64-hvm-ebs-nami"
    owner               = "979382823631"
    virtualization_type = "hvm"
  }
}

variable "min_size_slg" {
  description = "Minimum number of instances for autoscaling"
  default     = 1
}

variable "max_size_slg" {
  description = "Maximum number of instances for autoscaling"
  default     = 2
}

variable "dev_env" {
  description = "Development environment prefix for name and network"

  type = object ({
    name      = string
    network_prefix   = string
  })

  default     = {
    name      = "dev"
    network_prefix   = "10.0.
  }
}

variable eu_azs {
  description = "The availability zones in Europe"

  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

app_config = {
  autoscaling = {
    minimum = 1
    desired = 1
    maximum = 2
  }

  security_groups = {
    alb = {
      description         = "Application load balancer SG"
      ingress_cidr_blocks = ["0.0.0.0/0"]
      ingress_rules       = ["http", "http-8080", "https"]
    }
    app = {
      description         = "Application SG"
      ingress_cidr_blocks = ["0.0.0.0/0"]
      ingress_rules       = ["http", "https", "ssh"]
    }
  }

  template = {
    ami_id         = "ami-0b5eea76982371e91"
    instance_type  = "t3a.nano"
    key_name       = "testing-rsa-pair"
    user_data_file = "./3_user_data.sh"
  }
}

# variable "vpc_config" {
#   azs  = ["ca-central-1a", "ca-central-1b"]
#   cidr = "10.0.0.0/16"

#   public_subnet = {
#     cidr = ["10.0.1.0/24", "10.0.2.0/24"]
#   }

#   private_subnet = {
#     cidr = ["10.0.101.0/24", "10.0.102.0/24"]
#   }

#   vpc = {
#     enable_dns_hostnames = true
#     enable_dns_support   = true
#   }

#   nat = {
#     enabled            = true
#     single_nat_gateway = false
#   }
# }


variable "aws_region" {
  description = "The AWS region to create the VPC in."
  default     = "us-east-1"
}

variable "az-1a" {
  type    = string
  default = "us-east-1a"
}
variable "az-1b" {
  default = "us-east-1b"
}
variable "az-1c" {
  default = "us-east-1c"
}

variable "main_name" {
  default = "test2"
}

variable "meta" {
  default = "blabla"
}

variable "template" {
  type = map
  default = {
    "ami_id"         = "ami-0b5eea76982371e91"
    "instance_type"  = "t3a.nano"
    "key_name"       = "testing-rsa-pair"
    "user_data_file" = "./3_user_data.sh"
  }
}

variable "name" {
  type = map
  default = {
    "name_prefix_aws_launch_template" = "aws-launch-template"
    "name_prefix_aws_autoscaling_policy_up" = "autoscaling-policy-scale-up"
    "name_prefix_aws_autoscaling_policy_down" = "autoscaling-policy-scale-down"
    "name_aws_cloudwatch_metric_alarm_up" = "cloudwatch-cpu-up"
    "name_aws_cloudwatch_metric_alarm_down" = "cloudwatch-cpu-down"
  }
}
#variable "ami_id" {
#  default = "ami-0b5eea76982371e91"
#}
#variable "instance_type" {
#  default = "t3a.nano"
#}

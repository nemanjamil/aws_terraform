resource "aws_launch_template" "app" {
  name_prefix   = var.name.name_prefix_aws_launch_template
  image_id      = var.template.ami_id
  instance_type = var.template.instance_type
  //key_name      = var.template.key_name
  user_data = filebase64(var.template.user_data_file)

  ebs_optimized = true
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.alb.id]

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = aws_autoscaling_group.dynamic.id
#   elb                    = aws_lb.app-load-balancer.id
# }

resource "aws_autoscaling_group" "dynamic" {
  vpc_zone_identifier = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id,
    aws_subnet.public-us-east-1c.id
  ]
  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  # target_group_arns = [
  #   // ako stavimo ovo da li nam treba aws_autoscaling_attachment
  #   aws_lb_target_group.loadb-target-group.arn
  # ]

  health_check_grace_period = 180
  health_check_type         = "ELB" // ili EC2 ???
  default_cooldown          = 300
  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  # Automatically refresh all instances after the group is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  lifecycle {
    // https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
    // u dokumentaciji pise da treba da se doda lifecycle 
    // da li uopste mi ovo treba
    ignore_changes = [load_balancers, target_group_arns]
  }
}

// kontam da ovde treba da povezem ASG sa LB
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.dynamic.id
  elb                    = aws_lb.app-load-balancer.id
}

resource "aws_autoscaling_policy" "app_scale_up" {
  name                   = var.name.name_prefix_aws_autoscaling_policy_up
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dynamic.name
}

resource "aws_autoscaling_policy" "app_scale_down" {
  name                   = var.name.name_prefix_aws_autoscaling_policy_down
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dynamic.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_up" {
  alarm_name          = var.name.name_aws_cloudwatch_metric_alarm_up
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dynamic.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_down" {
  alarm_name          = var.name.name_aws_cloudwatch_metric_alarm_down
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dynamic.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_scale_down.arn]
}


resource "aws_launch_template" "app" {
  name_prefix   = "${var.meta.project_slug}-${var.meta.environment}"
  image_id      = var.app_config.template.ami_id
  instance_type = var.app_config.template.instance_type
  key_name      = var.app_config.template.key_name
  user_data     = filebase64(var.app_config.template.user_data_file)

  ebs_optimized = true
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.alb.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dynamic" {
  vpc_zone_identifier = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id,
    aws_subnet.public-us-east-1c.id
  ]
  min_size         = var.app_config.autoscaling.minimum
  max_size         = var.app_config.autoscaling.maximum
  desired_capacity = var.app_config.autoscaling.desired

  health_check_grace_period = 180
  health_check_type         = "ELB"
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
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_policy" "app_scale_up" {
  name                   = "${var.meta.project_slug}-${var.meta.environment}-app-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dynamic.name
}

resource "aws_autoscaling_policy" "app_scale_down" {
  name                   = "${var.meta.project_slug}-${var.meta.environment}-app-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.dynamic.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_up" {
  alarm_name          = "${var.meta.project_slug}-${var.meta.environment}-cpu-up"
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
  alarm_name          = "${var.meta.project_slug}-${var.meta.environment}-cpu-down"
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

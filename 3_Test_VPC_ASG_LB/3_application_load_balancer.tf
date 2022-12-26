resource "aws_lb" "app-load-balancer" {
  name               = "${local.main_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id,
    aws_subnet.public-us-east-1c.id
  ]

  tags = {
    Name = "${local.main_name}-alb"
  }

}

resource "aws_lb_listener" "application-lb" {
  load_balancer_arn = aws_lb.app-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loadb-target-group.arn
  }
}


#Target Groups

resource "aws_lb_target_group" "loadb-target-group" {
  name     = "${local.main_name}-loadb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.runner.id

  tags = {
    Name = "${local.main_name}-loadb-target-group"
  }
}

resource "aws_lb_target_group_attachment" "lb-tg-attach-1" {
  target_group_arn = aws_lb_target_group.loadb-target-group.arn
  target_id        = aws_autoscaling_group.dynamic.id
  port             = 80
}

# resource "aws_lb_target_group_attachment" "lb-tg-attach-2" {
#   target_group_arn = aws_lb_target_group.loadb-target-group.arn
#   target_id        = aws_instance.web_instance_2.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "lb-tg-attach-3" {
#   target_group_arn = aws_lb_target_group.loadb-target-group.arn
#   target_id        = aws_instance.web_instance_3.id
#   port             = 80
# }


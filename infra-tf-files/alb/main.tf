# Create application load balancer
resource "aws_lb" "app_alb" {
  name               = "app-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.app_security_group_id]
  subnets            = [var.subnet_1_id, var.subnet_2_id]

  enable_deletion_protection = false
}

# Assign target group to load balancer
resource "aws_lb_target_group" "app-alb-tg" {
  name        = "tf-app-alb-tg"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpcid

    lifecycle {
        create_before_destroy = true
    }

    health_check {
        path = var.health_check_path
        protocol = "HTTP"
        matcher = "200-499"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}


# Enable listerners of application load balancer
resource "aws_lb_listener" "port_80" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.app-alb-tg.arn
  # }
  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "port_443" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tf_app_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-alb-tg.arn
  }
}
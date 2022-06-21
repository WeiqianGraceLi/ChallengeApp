output "app_alb_target_group" {

    description = "The target group of alb"
    value = aws_lb_target_group.app-alb-tg.arn
}
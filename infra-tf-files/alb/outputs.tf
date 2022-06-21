output "app_alb_target_group" {

    description = "The target group of alb"
    value = aws_lb_target_group.app-alb-tg.arn
}

output "app_alb_zone_id" {

    description = "The zone id of alb"
    value = aws_lb.app_alb.zone_id
}

output "app_alb_dns_name" {

    description = "The dns name of alb"
    value = aws_lb.app_alb.dns_name
}
# Look up the existing hosted zone
data "aws_route53_zone" "app_zone" {
  name = var.hosted_zone_domain_name
  private_zone = false
}

# Create a record in the hosted zone
resource "aws_route53_record" "tf_app_record" {
  zone_id = data.aws_route53_zone.app_zone.zone_id 
  name    = var.record_domain_name 
  type    = "A"

  alias {
    name                   = var.app_alb_dns_name
    zone_id                = var.app_alb_zone_id
    evaluate_target_health = true
  }
}
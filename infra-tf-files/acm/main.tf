# Look up the public hosted zone
data "aws_route53_zone" "app_zone" {
  name = var.hosted_zone_domain_name
  private_zone = false
}

# Create SSL certificate
resource "aws_acm_certificate" "tf_app_cert" {
  domain_name       = var.record_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "tf_app_record" {
  for_each = {
    for dvo in aws_acm_certificate.tf_app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.app_zone.zone_id
}

resource "aws_acm_certificate_validation" "tf_app_cert_validation" {
  certificate_arn         = aws_acm_certificate.tf_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.tf_app_record : record.fqdn]
}


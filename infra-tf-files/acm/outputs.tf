output "tf_app_cert_arn" {

    description = "arn of the SSL certification"
    value = aws_acm_certificate.tf_app_cert.arn
  
}
variable "app_alb_zone_id" {
    description = "The zone id of alb"
}

variable "app_alb_dns_name" {
    description = "The dns name of alb"
}

variable "hosted_zone_domain_name" {
  description = "domain name of the hosted zone"
}

variable "record_domain_name" {
  description = "domain name of record in route53"
}

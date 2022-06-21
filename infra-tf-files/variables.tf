# This file defines variable type and set defualt value

variable "aws_profile" {
  type        = string
  description = "The name of the AWS Credential profile"
  default     = "default"
}

variable "aws_credentials_path" {
  description = "The file path of the file contains AWS Credentials"
  default     = ["~/.aws/credentials"]
}

variable "db_name" {
  description = "DB name of RDS database instance"
  default     = "postgres"
}

variable "db_user" {
  description = "Username of RDS database instance"
  default     = "dbuser"
}

variable "db_password" {
  description = "Password of RDS database instance"
  default     = "password"
}

variable "db_port" {
  description = "Port of RDS database instance"
  default     = "5432"
}

variable "db_listen_host" {
  description = "listen host of RDS database instance"
  default     = "0.0.0.0"
}

variable "health_check_path" {
  description = "path to validate the health of the application"
  default     = "/healthcheck/"
}

variable "hosted_zone_domain_name" {
  description = "domain name of the hosted zone"
  default     = "graceli99.com"
}

variable "record_domain_name" {
  description = "domain name of record in route53"
  default     = "servian.graceli99.com"
}


# # Uncommonet and modify the below variables if you need to enable remote backend

# variable "backend_s3_bucket_name" {
#   description = "The name of S3 bucket that contains the remote backend"
#   default = "servian_app_tf_backend"
# }

# variable "backend_s3_key" {
#   description = "the path to backend S3 key"
#   default = "servian_app/terraform.tfstate"
# }
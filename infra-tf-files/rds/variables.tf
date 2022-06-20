variable "db_name" {
  description = "DB name of RDS database instance"
}

variable "db_user" {
  description = "Username of RDS database instance"
}

variable "db_password" {
  description = "Password of RDS database instance"
}

variable "subnet_1_id" {
    description = "The id of subnet 1"
}

variable "subnet_2_id" {
    description = "The id of subnet 2"
}

variable "app_security_group_id" {
    description = "The id of security group"
}
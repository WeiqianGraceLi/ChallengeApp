variable "db_endpoint" {
    description = "The Endpoint address of the database"
}

variable "db_name" {
  description = "DB name of RDS database instance"
}

variable "db_user" {
  description = "Username of RDS database instance"
}

variable "db_password" {
  description = "Password of RDS database instance"
}

variable "db_port" {
  description = "Port of RDS database instance"
}

variable "db_listen_host" {
  description = "listen host of RDS database instance"
}

variable "app_alb_target_group" {
    description = "The target group of alb"  
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
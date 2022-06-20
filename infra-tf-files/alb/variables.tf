variable "app_security_group_id" {
    description = "The id of security group"
}
variable "subnet_1_id" {
    description = "The id of subnet 1"
}

variable "subnet_2_id" {
    description = "The id of subnet 2"
}
variable "vpcid" {
  description = "ID of the VPC in which security resources are deployed"
  type = string
}
variable "health_check_path" {
  description = "path to validate the health of the application"
}
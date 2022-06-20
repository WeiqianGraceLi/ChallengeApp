output "app_vpc_id" {

    description = "The VPC id"
    value = aws_vpc.app_vpc.id
  
}

output "subnet_1_id" {

    description = "The id of subnet 1"
    value = aws_subnet.app_subnet_1.id
  
}

output "subnet_2_id" {

    description = "The id of subnet 2"
    value = aws_subnet.app_subnet_2.id
  
}
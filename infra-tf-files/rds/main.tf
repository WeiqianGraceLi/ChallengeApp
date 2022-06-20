# Create RDS database instance
resource "aws_db_instance" "postgres" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "10.20"
  instance_class       = "db.t3.micro"
  identifier           = "app-db-postgres" 
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.postgres10"
  vpc_security_group_ids = [var.app_security_group_id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
  multi_az             = true 
}

# Assign database with subnets
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [var.subnet_1_id, var.subnet_2_id]

  tags = {
    Name = "My DB subnet group"
  }
}


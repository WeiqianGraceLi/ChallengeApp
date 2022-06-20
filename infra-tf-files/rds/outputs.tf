output "db_endpoint" {

    description = "The Endpoint of the database"
    value = aws_db_instance.postgres.endpoint
  
}
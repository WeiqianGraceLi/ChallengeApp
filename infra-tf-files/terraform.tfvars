# Input actual value of the the variables
aws_profile = "default"
aws_credentials_path = ["~/.aws/credentials"]
db_name = "postgres"
db_user = "dbuser"
db_password = "password"
health_check_path = "/healthcheck/"


# Uncommonet and modify the below variables if you need to enable remote backend
# backend_s3_bucket_name = "servian_app_tf_backend"
# backend_s3_key = "servian_app/terraform.tfstate"
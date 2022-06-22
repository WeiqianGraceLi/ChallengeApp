## Pre-requisites
- Terraform
- AWS CLI
- An AWS IAM user with administration access
- A public hosted zone on Route53


## Process instructions

1. Configure AWS CLI, authenticate to an AWS account, and make sure the credentials and configuration settings are stored in a local file. 


2.  Get into directory `infra-tf-files`, and modify the variables in file `terraform.tfvars`. 
  
      **aws_profile**  
      Put in the AWS credentials profile name

      **aws_credentials_path**  
      Put in the file path where the AWS credentials file stores

      **db_name**   
      Name the database, or leave it as it is

      **db_user**  
      Set the database username, or leave it as it is

      **db_password**  
      Set the database password, or leave it as it is

      **hosted_zone_domain_name**  
      Put in the domain name of an existing hosted zone in Route53

      **record_domain_name**  
      Set the domain name of the Route53 record

3. Change directory to `infra-tf-files` run the commands below to start provisioning

```
terraform init 
terraform apply -auto-approve
```
4. Run the command below to delete the resources
```
terraform destroy -auto-approve
```

## Architectural Overview

View https://servian.graceli99.com/ for deployed website based on this solution
- Used ECS to run dockerized application in a container, and host with fargate
- Created record in Route53, so that website can be accessed via domain name
- Used ACM to apply SSL certificate on website, to ensure security for online communications
- Used Application load balancer to redirect HTTP to HTTPS
- Only allow traffic from Application load balancer, so that servers in public subnet cannot be accessed directly with public IP
- Autoscaling based on CPU and Memory to ensure high availability.
- Multi-AZ infra with 2 subnets
- Used security group to restrict traffic to certain ports. 
![image](https://user-images.githubusercontent.com/98030110/174909536-3988011a-9bc0-4e9f-b099-935a4123ee3c.png)

## Future Improvements:
- If this is a group project, a remote backend should be used. The remote backend can be achieved with Terraform Cloud or AWS S3 & DynamoDB. A local backend is used in this solution as it is an individual project, more pre-requisites are required if a remote backend is used.

- Store RDS in private subnets and apply NAT Gateway for outbound traffic, for a more secure database.
- Use Vault to store environment variables as a more secure solution.
- Use multiple replication databases to improve availability and performance.  
- Setting for RDS has enabled Multi-AZ, however Multi-AZ option is not available for free tier database instances, if user traffic increases, should use multi-AZ database for high availability.

# Terraform AWS Auto Scaling with ALB, RDS, S3

Inspired from https://github.com/erozedguy/Terraform-AWS-Auto-Scaling-and-ALB

## Description

## Architecture

Terraform will create a VPC in region "eu-west-1" :

- 1 Internet Gateway
- 3 Public Subnets
- 1 Auto Scaling Group and 1 Launch Template
- 1 Application Load Balancer
- 1 RDS mysql
- 1 s3 bucket

## Usage

- You can apply terraform by using the following command:

```t
cp ./aws-keys.sample.sh ./aws-keys.sh
# edit file to add AWS secret key and access key
vim ./aws-keys.sh
chmod +x ./aws-keys.sh
source ./aws-keys.sh
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

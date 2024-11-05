## Overview
This Terraform module deploys a Gitea server on AWS. It provisions an EC2 instance with Docker and Docker Compose, configures security groups, and starts Gitea with a PostgreSQL database using the provided `docker-compose.yaml`.

#### Prerequisites
1. **AWS Access**: Ensure AWS credentials are configured locally.
2. **S3 Bucket for Terraform State**: Manually set the S3 backend configuration in `main.tf`:
   ```hcl
   terraform {
     backend "s3" {
       bucket = "your_bucket_name"
       key    = "gitea/terraform.tfstate"
       region = "your_region"
     }
   }
   ```
3. **Network**: Ensure the VPC (`vpc_name`) and Subnet (`subnet_name`) exist and are tagged appropriately.
4. **Docker Compose File**: Ensure `docker-compose.yaml` is in the same directory.

#### Usage
1. **Set Variables**: Complete the `terraform.tfvars` file:
   ```hcl
   s3_bucket         = "your_bucket_name"
   instance_type     = "t2.small"
   vpc_name          = "your_vpc_name"
   subnet_name       = "your_public_subnet_name"
   ```

2. **Apply**:
   ```bash
   terraform init
   terraform apply
   ```

   This will deploy Gitea on an EC2 instance accessible via HTTP (port 3000) and SSH (port 22).

3. **Retrieve the SSH Key**:
   After `terraform apply`, output the SSH private key to a `.pem` file for secure access:
   ```bash
   terraform output -raw private_key > gitea_key.pem
   chmod 400 gitea_key.pem
   ```

4. **Access the Instance via SSH**:
   Use the `.pem` key file to connect to the instance:
   ```bash
   ssh -i gitea_key.pem ec2-user@<instance-public-ip> -p 22
   ```

#### Web Access

1. **Get the Public IP**: After applying the Terraform configuration, your URL will print to the console. You can also retrieve the EC2 instance’s public IP from the AWS console.

2. **Access the UI**: Open a web browser and go to:
   ```plaintext
   http://<instance-public-ip>:3000
   ```

This additional instruction in **Prerequisites** clarifies the manual S3 backend setup for your friends using this module.
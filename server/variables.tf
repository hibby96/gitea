variable "aws_region" {
  description = "AWS Region for deployment"
  default     = "us-east-2"
}

variable "s3_key" {
  description = "S3 key for Terraform backend state"
  default     = "gitea/terraform.tfstate"
}

variable "ami_name_pattern" {
  description = "AMI name pattern for Gitea instance"
  default     = "amzn2-ami-hvm-*"
}

variable "instance_type" {
  description = "EC2 instance type for Gitea deployment"
  default     = "t2.small"
}

variable "vpc_name" {
  description = "VPC tag name for lookup"
}

variable "subnet_name" {
  description = "Subnet tag name for public subnet"
  default     = "public"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  default     = "gitea-key"
}

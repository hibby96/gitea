provider "aws" {
  region = var.aws_region
}

provider "http" {}

terraform {
  backend "s3" {
    bucket = "s3_bucket"
    key    = "gitea/terraform.tfstate"
    region = "us-east-2"
  }
}

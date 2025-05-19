terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnet from the default VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Use an existing key pair
resource "aws_key_pair" "example_key" {
  key_name = "example-key"
}

# EC2 instance using default VPC and subnet
resource "aws_instance" "example_ec2" {
  ami             = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type   = "t2.micro"
  subnet_id       = element(data.aws_subnet_ids.default.ids, 0)  # First default subnet
  security_groups = ["default"]  # Use default security group
  key_name        = aws_key_pair.example_key.key_name

  tags = {
    Name = "example-ec2-instance"
  }
}

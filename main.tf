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

# Get the default subnets from the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the security group named "def" within the default VPC
data "aws_security_group" "def" {
  filter {
    name   = "group-name"
    values = ["def"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Use an existing key pair (no resource creation, just reference)
data "aws_key_pair" "example_key" {
  key_name = "example-key"
}

# EC2 instance using default VPC and subnet
resource "aws_instance" "example_ec2" {
  ami                  = "ami-084568db4383264d4"  # Amazon Linux 2 AMI
  instance_type        = "t2.micro"
  subnet_id            = element(data.aws_subnets.default.ids, 0)  # First default subnet
  security_group_ids   = [data.aws_security_group.def.id]  # Use security group ID
  key_name             = data.aws_key_pair.example_key.key_name

  tags = {
    Name = "example-ec2-instance"
  }
}

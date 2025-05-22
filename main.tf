#terra
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_key_pair" "example_key" {
  key_name = "example-key"
}

resource "aws_security_group" "de" {
  name        = "de"
  description = "Security group for EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "de"
  }
}

module "example_ec2" {
  source             = "./modules/ec2"
  ami                = "ami-084568db4383264d4"
  instance_type      = "t2.micro"
  subnet_id          = element(data.aws_subnets.default.ids, 0)
  security_group_ids = [aws_security_group.de.id]
  key_name           = data.aws_key_pair.example_key.key_name
  instance_name      = "example-ec21-instance"
}

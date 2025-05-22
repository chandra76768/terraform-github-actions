

provider "aws" {
  region = "us-east-1"
}

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
  description = "Security group def for example EC2"
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
  instance_name      = "example-single-instance"
}

### Root Module - variables.tf (optional)
# No variables needed at root since values are hardcoded in main.tf


### Module - modules/ec2/main.tf

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name

  tags = {
    Name = var.instance_name
  }
}


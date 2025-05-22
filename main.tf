#testing
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

locals {
  ec2_instances = {
    abc = {
      ami            = "ami-084568db4383264d4"
      instance_type  = "t2.micro"
      subnet_index   = 0
      instance_name  = "abc"
    },
    abc2 = {
      ami            = "ami-084568db4383264d4"
      instance_type  = "t2.micro"
      subnet_index   = 1
      instance_name  = "abc2"
    }
  }
}

module "ec2_instances" {
  source  = "./modules/ec2"
  for_each = local.ec2_instances

  ami                = each.value.ami
  instance_type      = each.value.instance_type
  subnet_id          = element(data.aws_subnets.default.ids, each.value.subnet_index)
  security_group_ids = [aws_security_group.de.id]
  key_name           = data.aws_key_pair.example_key.key_name
  instance_name      = each.value.instance_name
}

variable "ami" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
}

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the instance"
}

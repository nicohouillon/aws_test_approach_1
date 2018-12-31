variable "region" {
  description = "AWS region"
}
variable "shared_credentials_file" {}
variable "profile" {}

# Ubuntu Precise 16.04 LTS (x64)
variable "aws_amis" {
  default = {
    us-east-1 = "ami-f4cc1de2"
    us-west-2 = "ami-a58d0dc5"
  }
}
variable "vpc_cidr" {
    description = "CIDR for VPC"
}
variable ssh_key{
	description = "ec2 ssh key"
}

variable "availability_zones" {
  type = "list"
  description = "AWS Region Availability Zones"
}

variable "public_subnet_cidr" {
  type = "list"
  description = "Public Subnet CIDR Block"
}
variable "private_subnet_cidr" {
  type = "list"
  description = "Private Subnet CIDR Block"
}
provider "aws" {
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
  region                  = "${var.region}"
}


data "aws_ami" "custom_ami" {
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["web-server"]
  }
  filter {
    name   = "name"
    values = ["packer-*"]
  }
}
data "template_file" "userdata" {
  template = "${file("scripts/userdata.sh")}"
  }
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
data "aws_availability_zones" "allzones" {}




output "ELB DNS" {
  value = "${aws_elb.elb.dns_name}"
}
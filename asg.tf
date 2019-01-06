## Creating Launch Configuration
resource "aws_launch_configuration" "as_launch_config" {
  image_id               = "${data.aws_ami.custom_ami.id}"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.web_sg.id}", "${aws_security_group.allow_ssh.id}"]
  key_name               = "${var.ssh_key}"
  user_data = "${data.template_file.userdata.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}


## Creating AutoScaling Group
resource "aws_autoscaling_group" "web_as_group" {
  launch_configuration = "${aws_launch_configuration.as_launch_config.id}"
  #availability_zones = ["${data.aws_availability_zones.allzones.names}"]
  #availability_zones        = "${var.availability_zones}"
  vpc_zone_identifier       = ["${aws_subnet.public_subnet.*.id}"]
  min_size = 2
  max_size = 5
  load_balancers = ["${aws_elb.elb.name}"]
  health_check_type = "ELB"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]


  tag {
    key = "Name"
    value = "ASG"
    propagate_at_launch = true
  }
}

## SG for web instances
resource "aws_security_group" "web_sg" {
name = "security_group_for_web_server"
vpc_id = "${aws_vpc.vpc.id}"
ingress {
  from_port = 80
    to_port = 80
    protocol = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.elb_sg.id}"]
}
lifecycle {
create_before_destroy = true
}
}
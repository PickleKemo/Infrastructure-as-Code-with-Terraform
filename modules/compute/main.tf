# modules/compute/main.tf
variable "instance_type" { type = string }
variable "ami_id" { type = string }

resource "aws_launch_template" "this" {
  name_prefix   = "${var.env}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.env}-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_ids
}

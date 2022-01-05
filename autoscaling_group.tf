resource "aws_launch_template" "test" {
  name_prefix            = "test"
  image_id               = "ami-0f7cd40eac2214b37"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.front.id]
  user_data              = "${base64encode(data.template_file.user_data.rendered)}"
  key_name               = "ruben_key"
}

resource "aws_autoscaling_group" "bar" {
  #availability_zones = ["eu-west-3a, eu-west-3b"]
  name             = "test"
  desired_capacity = 2
  max_size         = 5
  min_size         = 1


  target_group_arns = [aws_lb_target_group.front.arn]

  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]


  launch_template {
    id      = aws_launch_template.test.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Api"
    propagate_at_launch = true
  }
}
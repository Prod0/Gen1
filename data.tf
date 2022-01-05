data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("cloud-init.sh")
  vars = {
    dns_lb = "${aws_lb.db_lb.dns_name}"
  }
}

data "template_file" "db1Sh" {
  template = filebase64("db1.sh")
}


data "template_file" "db2Sh" {
  template = filebase64("db2.sh")
}
resource "aws_instance" "first_database" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bdd1.id]
  associate_public_ip_address = true
  key_name               = "ruben_key"
  subnet_id = aws_subnet.public_1.id
  private_ip = "10.0.0.100"
  user_data_base64 =  data.template_file.db1Sh.rendered

  tags = {
    Name = "first_database"
  }
}

resource "aws_instance" "second_database" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bdd1.id]
  associate_public_ip_address = true
  key_name               = "ruben_key"
  subnet_id = aws_subnet.public_2.id
  private_ip = "10.0.1.100"
  user_data_base64 =  data.template_file.db2Sh.rendered

  tags = {
    Name = "second_database"
  }
}

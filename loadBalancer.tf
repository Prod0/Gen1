resource "aws_lb" "front_lb" {
  name               = "frontLoadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.front_lb.id]
  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Environment = "Loadbalancer Front"
  }
}

resource "aws_lb_target_group" "front" {
  name     = "frontLoadbalancer"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_listener" "front" {
  load_balancer_arn = aws_lb.front_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}


#############################################
#############################################
#############################################
#############################################


resource "aws_lb" "db_lb" {
  name               = "DatabaseLoadbalancer"
  internal           = true
  load_balancer_type = "network"
  # subnets = [
  #   aws_subnet.public_1.id,
  #   aws_subnet.public_2.id
  # ]
   subnet_mapping {
    subnet_id            = aws_subnet.public_1.id
    private_ipv4_address = "10.0.0.15"
  }

  subnet_mapping {
    subnet_id            = aws_subnet.public_2.id
    private_ipv4_address = "10.0.1.15"
  }

  tags = {
    Environment = "Loadbalancer Bdd"
  }
}

resource "aws_lb_target_group" "bdd" {
  name     = "BddLoadbalancer"
  port     = 3306
  protocol = "TCP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_target_group_attachment" "bdd1" {
  target_group_arn = aws_lb_target_group.bdd.arn
  target_id        = aws_instance.first_database.id
}

resource "aws_lb_target_group_attachment" "bdd2" {
  target_group_arn = aws_lb_target_group.bdd.arn
  target_id        = aws_instance.second_database.id
}

resource "aws_lb_listener" "bdd" {
  load_balancer_arn = aws_lb.db_lb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bdd.arn
  }
}
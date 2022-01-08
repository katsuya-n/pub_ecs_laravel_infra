resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-sg-alb"
  description = "sg alb"
  vpc_id      = var.vpc_id

  ingress {
    description      = "my ip"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.allow_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-alb"
  }
}
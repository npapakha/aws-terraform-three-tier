resource "aws_security_group" "elb_security_group" {
  name   = "${var.name}-public-security-group"
  vpc_id = aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
  }

  dynamic "ingress" {
    for_each = var.elb_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
    }
  }
}

resource "aws_security_group" "app_security_group" {
  name   = "${var.name}-app-security-group"
  vpc_id = aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
  }

  dynamic "ingress" {
    for_each = var.app_ports
    content {
      security_groups = [aws_security_group.elb_security_group.id]
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
    }
  }
}

resource "aws_security_group" "db_security_group" {
  name   = "${var.name}-db-security-group"
  vpc_id = aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
  }

  dynamic "ingress" {
    for_each = var.db_ports
    content {
      security_groups = [aws_security_group.app_security_group.id]
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
    }
  }
}

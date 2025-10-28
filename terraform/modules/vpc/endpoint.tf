resource "aws_security_group" "vpc_endpoint_security_group" {
  name   = "${var.name}-vpc-endpoint-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each            = toset(var.interface_endpoints)
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.app_subnet)[*].id
  security_group_ids  = [aws_security_group.vpc_endpoint_security_group.id]
  private_dns_enabled = true

  tags = { Name = "${var.name}-${each.key}-vpc-interface-endpoint" }
}

resource "aws_vpc_endpoint" "gateway_endpoints" {
  for_each = toset(var.gateway_endpoints)

  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.app_route_table.id,
  ]

  tags = { Name = "${var.name}-${each.key}-vpc-gateway-endpoint" }
}

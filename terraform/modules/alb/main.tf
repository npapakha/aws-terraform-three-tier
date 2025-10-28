resource "aws_lb" "load_balancer" {
  name                             = "${var.name}-alb"
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true

  subnets         = var.subnets
  security_groups = var.security_groups
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name                 = "${var.name}-lb-target-group"
  port                 = var.target_port
  protocol             = var.target_protocol
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = var.target_protocol
    interval            = 30
  }
}

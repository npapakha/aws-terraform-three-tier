resource "aws_ecs_cluster" "cluster" {
  name = var.name
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.name}"
}

resource "aws_ecs_service" "service" {
  name = var.name

  cluster       = aws_ecs_cluster.cluster.arn
  desired_count = var.desired_count
  launch_type   = "FARGATE"

  task_definition = aws_ecs_task_definition.task_definition.arn

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    container_name   = var.name
    container_port   = var.port
    target_group_arn = var.aws_lb_target_group_id
  }
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "task_definition" {
  cpu    = var.cpu
  memory = var.memory

  family       = "${var.name}-service"
  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = var.name,
      image       = var.aws_ecr_url,
      essential   = true,
      environment = var.environment,
      healthCheck = {
        command  = ["CMD-SHELL", "curl -f http://localhost:${var.port}/ || exit 1"]
        interval = 30
        timeout  = 5
        retries  = 3
      },
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name,
          awslogs-region        = data.aws_region.current.region,
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = var.port,
          hostPort      = var.port
        }
      ]
    }
  ])
}


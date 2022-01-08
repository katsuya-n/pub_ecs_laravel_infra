resource "aws_ecs_cluster" "backend" {
  name = "${var.name_prefix}-ecs"

  tags = {
    Name = "${var.name_prefix}-ecs"
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name_prefix}-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name   = "app"
      image  = "${var.backend_ecr_repository_url}:latest"
      cpu    = 128
      memory = 256

      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
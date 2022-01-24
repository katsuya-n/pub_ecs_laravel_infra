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

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.name_prefix}-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = var.ecs_task_iam_role_arn
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

resource "aws_ecs_service" "backend" {
  name                   = "${var.name_prefix}-service"
  cluster                = aws_ecs_cluster.backend.id
  task_definition        = aws_ecs_task_definition.backend.arn
  desired_count          = var.backend_desired_count
  launch_type            = "FARGATE"
  scheduling_strategy    = "REPLICA"
  enable_execute_command = true
  force_new_deployment   = true

  network_configuration {
    security_groups = [var.sg_container_id]
    subnets = [
      var.subnet_container_1a_id,
      var.subnet_container_1b_id
    ]
  }

  load_balancer {
    target_group_arn = var.alb_tg_blue_arn
    container_name   = "app"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

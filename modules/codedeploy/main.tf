resource "aws_codedeploy_app" "backend" {
  compute_platform = "ECS"
  name             = "${var.name_prefix}-app"
}

resource "aws_codedeploy_deployment_group" "backend" {
  app_name               = aws_codedeploy_app.backend.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.name_prefix}-deploy-group"
  service_role_arn       = var.backend_ecs_code_deploy_iam_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 3
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.backend_ecs_cluster_name
    service_name = var.backend_ecs_service
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.backend_alb_listener_blue_arn]
      }

      target_group {
        name = var.backend_alb_tg_blue_name
      }

      target_group {
        name = var.backend_alb_tg_green_name
      }
    }
  }
}
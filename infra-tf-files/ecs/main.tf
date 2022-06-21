# Create iam role for ecs task execution
resource "aws_iam_role" "tf_ecs_execution_role" {
  name = "tf_ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tf_ecs_execution_role"
  }
}


# Attach iam role with policy for ecs task execution
resource "aws_iam_role_policy_attachment" "tf_ecs_execution_attach" {
  role       = aws_iam_role.tf_ecs_execution_role.name
  policy_arn ="arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create task definition for ecs service
resource "aws_ecs_task_definition" "app_ecs_task" {
  family = "app_ecs_task"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.tf_ecs_execution_role.arn
  task_role_arn = aws_iam_role.tf_ecs_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu       = 256
  memory    = 512
  
  container_definitions = jsonencode([
    {
      name      = "app_container"
      image     = "servian/techchallengeapp:latest"
      essential = true
      entryPoint = ["sh","-c"]
      command: [ "./TechChallengeApp updatedb -s;./TechChallengeApp serve"]
      environment: [
      {"name": "VTT_DBHOST", "value": var.db_endpoint},
      {"name": "VTT_DBNAME", "value": var.db_name},
      {"name": "VTT_DBPASSWORD", "value": var.db_password},
      {"name": "VTT_DBPORT", "value": var.db_port}, 
      {"name": "VTT_DBUSER", "value": var.db_user},
      {"name": "VTT_LISTENHOST", "value": var.db_listen_host}
      ]

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    },
  ])

}

# Create ecs fargate cluster
resource "aws_ecs_cluster" "tf_app_cluster" {
  name = "tf_app_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
}

# Create ecs service based on task definition
resource "aws_ecs_service" "app_ecs_service" {
  name            = "app_ecs_service"
  cluster         = aws_ecs_cluster.tf_app_cluster.id
  task_definition = aws_ecs_task_definition.app_ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  health_check_grace_period_seconds = 30

  network_configuration {
    subnets = [var.subnet_1_id, var.subnet_2_id]
    security_groups = [var.app_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.app_alb_target_group
    container_name   = "app_container"
    container_port   = 3000
  }

}

# Set autoscaling for ecs service
resource "aws_appautoscaling_target" "app_ecs_autoscaling_target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.tf_app_cluster.name}/${aws_ecs_service.app_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "app_ecs_autoscaling_memory" {
  name               = "app_ecs_autoscaling_memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.app_ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_ecs_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "app_ecs_autoscaling_cpu" {
  name               = "app_ecs_autoscaling_cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.app_ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_ecs_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
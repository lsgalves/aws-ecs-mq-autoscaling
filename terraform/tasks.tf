resource "aws_ecs_task_definition" "web" {
  family                   = "web-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "flower"
      image     = "mher/flower:2.0"
      essential = true
      environment = [
        {
          name  = "CELERY_BROKER_URL"
          value = aws_mq_broker.rabbitmq.instances[0].endpoints[0]
        },
        {
          name  = "FLOWER_UNAUTHENTICATED_API"
          value = "true"
        }
      ]
      portMappings = [
        {
          containerPort = 5555
          hostPort      = 5555
        }
      ]
    },
    {
      name      = "api"
      image     = "ghcr.io/lsgalves/aws-ecs-mq-autoscaling-api:master"
      essential = true
      environment = [
        {
          name  = "BROKER_URL"
          value = aws_mq_broker.rabbitmq.instances[0].endpoints[0]
        },
        {
          name  = "BROKER_USERNAME"
          value = var.broker_user
        },
        {
          name  = "BROKER_PASSWORD"
          value = var.broker_password
        }
      ]
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name      = "Example ECS Web Task Definition"
    PoweredBy = "Terraform"
  }

  depends_on = [aws_mq_broker.rabbitmq]
}

resource "aws_ecs_task_definition" "worker" {
  family                   = "worker-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "worker"
      image     = "ghcr.io/lsgalves/aws-ecs-mq-autoscaling-worker:master"
      essential = true
      environment = [
        {
          name  = "BROKER_URL"
          value = aws_mq_broker.rabbitmq.instances[0].endpoints[0]
        },
        {
          name  = "BROKER_USERNAME"
          value = var.broker_user
        },
        {
          name  = "BROKER_PASSWORD"
          value = var.broker_password
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    Name      = "Example ECS Web Task Definition"
    PoweredBy = "Terraform"
  }

  depends_on = [aws_mq_broker.rabbitmq]
}

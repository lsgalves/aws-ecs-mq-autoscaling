resource "aws_security_group" "web" {
  name        = "example-web-service-sg"
  description = "Security group for accesss Flower and API services"

  tags = {
    Name      = "Example Flower and API services"
    PoweredBy = "Terraform"
  }
}

resource "aws_security_group_rule" "example_flower_ingress" {
  description       = "Allow Flower access from all sources"
  type              = "ingress"
  from_port         = 5555
  to_port           = 5555
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "example_api_ingress" {
  description       = "Allow web API access from all sources"
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "example_web_egress" {
  description       = "Allow all egress traffic from web services"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_ecs_service" "web" {
  name                          = "example-web-service"
  cluster                       = aws_ecs_cluster.example.id
  task_definition               = aws_ecs_task_definition.web.arn
  desired_count                 = 1
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    subnets          = data.aws_subnets.vpc_subnets.ids
    security_groups  = [aws_security_group.web.id]
    assign_public_ip = true
  }

  tags = {
    Name      = "Example Web Service"
    PoweredBy = "Terraform"
  }

  depends_on = [
    aws_ecs_cluster.example,
    aws_ecs_task_definition.web,
    aws_mq_broker.rabbitmq
  ]
}

resource "aws_ecs_service" "worker" {
  name                          = "example-worker-service"
  cluster                       = aws_ecs_cluster.example.id
  task_definition               = aws_ecs_task_definition.worker.arn
  desired_count                 = 1
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    subnets          = data.aws_subnets.vpc_subnets.ids
    security_groups  = [aws_security_group.web.id]
    assign_public_ip = true
  }

  tags = {
    Name      = "Example Worker Service"
    PoweredBy = "Terraform"
  }

  depends_on = [
    aws_ecs_cluster.example,
    aws_ecs_task_definition.worker,
    aws_mq_broker.rabbitmq
  ]
}

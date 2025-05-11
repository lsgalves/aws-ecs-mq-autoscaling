resource "aws_mq_broker" "rabbitmq" {
  broker_name                = "example-rabbitmq-broker"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  auto_minor_version_upgrade = true
  host_instance_type         = "mq.t3.micro"
  deployment_mode            = "SINGLE_INSTANCE"
  publicly_accessible        = true
  subnet_ids                 = [data.aws_subnets.vpc_subnets.ids[0]]

  user {
    username = var.broker_user
    password = var.broker_password
  }

  logs {
    general = true
  }

  tags = {
    Name      = "Example MQ Broker"
    PoweredBy = "Terraform"
  }
}

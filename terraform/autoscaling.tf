resource "aws_appautoscaling_target" "example_ecs_worker_autoscaling" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.example.name}/${aws_ecs_service.worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.worker]
}

resource "aws_appautoscaling_policy" "scale_up_autpscaling_policy" {
  name               = "example-queue-high-scaling"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.example_ecs_worker_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.example_ecs_worker_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.example_ecs_worker_autoscaling.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 20.0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_autpscaling_policy" {
  name               = "example-queue-down-scaling"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.example_ecs_worker_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.example_ecs_worker_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.example_ecs_worker_autoscaling.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 5.0
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "example_scale_up_alarm" {
  alarm_name          = "example-queue-high-messages-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MessageReadyCount"
  namespace           = "AWS/AmazonMQ"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Too many messages in queue"
  treat_missing_data  = "missing"

  alarm_actions = [aws_appautoscaling_policy.scale_up_autpscaling_policy.arn]

  dimensions = {
    Broker      = aws_mq_broker.rabbitmq.broker_name
    Queue       = "celery"
    VirtualHost = "/"
  }

  tags = {
    Name      = "Example scale up alarm"
    PoweredBy = "Terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "example_scale_down_alarm" {
  alarm_name          = "example-queue-low-messages-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "MessageReadyCount"
  namespace           = "AWS/AmazonMQ"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Few messages in queue"
  treat_missing_data  = "missing"

  alarm_actions = [aws_appautoscaling_policy.scale_down_autpscaling_policy.arn]

  dimensions = {
    Broker      = aws_mq_broker.rabbitmq.broker_name
    Queue       = "celery"
    VirtualHost = "/"
  }

  tags = {
    Name      = "Example scale down alarm"
    PoweredBy = "Terraform"
  }
}

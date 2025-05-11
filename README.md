# AWS ECS Fargate + Autoscaling over Amazon MQ

This project aims to show how to use AWS ECS with auto scaling based on the number of messages in an Amazon MQ queue.

## Setup example project

```bash
docker compose up -d --build

# Testing
while :; do
  curl -X POST 'http://localhost:5000/sum?x=5&y=7'
  sleep 1
done
```

- Flower: http://localhost:5555
- RabbitMQ Management: http://localhost:15672

## Setup example project in AWS

```bash
cd terraform/

# Set variables in terraform/variables.tf
vi terraform.tfvars

terraform init
terraform apply
```

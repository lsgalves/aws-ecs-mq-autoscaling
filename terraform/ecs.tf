resource "aws_ecs_cluster" "example" {
  name = "example-cluster"

  tags = {
    Name      = "Example ECS Cluster"
    PoweredBy = "Terraform"
  }
}

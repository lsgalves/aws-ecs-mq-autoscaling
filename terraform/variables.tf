variable "aws_access_key" {
  description = "AWS access key"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  sensitive   = true
}

variable "vpc_id" {
  description = "Default VPC ID"
  type        = string
}

variable "broker_user" {
  description = "RabbitMQ broker user"
  type        = string
  default     = "example-user"
}

variable "broker_password" {
  description = "RabbitMQ broker password"
  type        = string
  sensitive   = true
  default     = "example-password"
}

# variables.tf: Define variables.

variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "db_username" {
  description = "The username for the RDS instance"
  default     = "admin"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "ec2_key_pair" {
  description = "The name of the EC2 key pair"
  default     = "my-key-pair"
}

variable "instance_count" {
  description = "The number of EC2 instances"
  default     = 2
}

variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t2.micro"
}

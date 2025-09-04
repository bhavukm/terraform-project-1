variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to deploy resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ASG and ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for instances and ALB"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "alarm_threshold" {
  description = "CPU Utilization threshold for alarm"
  type        = number
  default     = 25
}

variable "notification_email" {
  description = "Email address for SNS notification"
  type        = string
}
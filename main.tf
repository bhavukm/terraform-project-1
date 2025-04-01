// Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "your-vpc-id"    #You may use variables here
}

resource "aws_launch_template" "demolt" {
  name          = "demolt"
  image_id      = "your-ami-id"  #You may use variables here
  instance_type = "t2.micro"
  key_name      = "kp"

  network_interfaces {
    security_groups = ["LT-security-group-id"]   #You may use variables here
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = "ec2-ssm"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ltdemo"
    }
  }
}

resource "aws_autoscaling_group" "demoasg" {
  name                  = "demoasg"
  min_size              = 2
  desired_capacity      = 2
  max_size              = 3
  vpc_zone_identifier   = ["subnet-id-1", "subnet-id-2"]  #You may use variables here

  launch_template {
    id      = aws_launch_template.demolt.id
    version = "$Latest"
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["alb-security-group-id"]    #You may use variables here
  subnets           = ["subnet-id-1", "subnet-id-2"]    #You may use variables here
}

resource "aws_lb_target_group" "lt_ag" {
  name       = "lt-ag"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = data.aws_vpc.main.id
  target_type = "instance"
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lt_ag.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.demoasg.id
  alb_target_group_arn   = aws_lb_target_group.lt_ag.arn
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "sp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.demoasg.name
}

resource "aws_cloudwatch_metric_alarm" "cpuutilization_alarm" {
  alarm_name          = "cpuutilization_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 40
  alarm_actions      = [aws_autoscaling_policy.scale_up.arn, aws_sns_topic.cpu.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demoasg.name
  }
}

resource "aws_sns_topic" "cpu" {
  name         = "cpu"
  display_name = "cpu"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu.arn
  protocol  = "email-json"
  endpoint  = "your-email-id"   #You may use variables here
}
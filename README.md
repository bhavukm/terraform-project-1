# tf-aws-asg-lb-cw
Automating AWS Infrastructure with Terraform. This project deploys a Web Application on AWS EC2 Instances as part of an AutoScaling Group (ASG). The AutoScaling Group is integrated with an Application Load Balancer (ALB) and a Launch template (LT). The LT utilizes a custom AWS AMI (Amazon Machine Image) that already has a static website code with an Apache web server configured. The ASG also has a Dynamic Scaling policy to increase the number of instances in the ASG automatically when the Average CPU Utilization of the ASG breaches the threshold of 40 percent. The scaling event is triggered via a CloudWatch Alarm that also sends an AWS SNS (Simple Notification Service) -based Email to the users.

**YouTube Video URL:**

![image](https://github.com/user-attachments/assets/c65bda41-84be-45b6-bb74-74add555c2b9)

**Knowledge of concepts that are required before this video have been covered in my earlier YouTube Videos, do check these out:**

AWS EC2 Instance Creation (Manually from UI): https://youtu.be/FOHXylL8e2Q

AWS EC2 Instance Creation (with Terraform script) and Terraform Installation: https://youtu.be/JkxB_d8XLN8

The entire AWS Project Deployed Manually from UI: https://youtu.be/dMUQTQS1l3g

Steps to use the Terraform script to automatically deploy the infrastructure:

Resources that should be provisioned before using the Terraform script:

1. An AWS Account with a Bastion Host (EC2 with Amazon Linux 2023 OS) where Terraform is installed and configured.

2. An IAM Role is attached to the Bastion Host with "Administrator" access. For help with IAM Role creation, see the following YouTube Video: https://youtu.be/TF9oisb1QJQ

3. AWS CLI configured on the Bastion Host (In case we need it. Amazon Linux AMI already has AWS CLI installed, so no need to install or configure if you use that AMI).

4. The AMI ID should already be available to be used with the Launch Template. I am keeping it separate from the Terraform project so that when I destroy the project (terraform destroy), the AMI is still available

as I use it with different projects. If help is required to create this AMI, please refer:

YouTube Video: https://youtu.be/FOHXylL8e2Q

or

GitHub Repo: https://github.com/bhavukm/webapp-asg-alb.git

5. The Security Groups for the LT and ALB should already be available. The reason for doing that is the same as in point number 4. If you need help with the creation of Security Groups, please refer to:

YouTube Video: https://youtu.be/FOHXylL8e2Q

6. The infrastructure is deployed in a default VPC and subnets that are available per region (in this case, us-east-1) in an AWS account.

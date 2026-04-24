terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_elastic_beanstalk_application" "securescan" {
  name        = var.app_name
  description = "SecureScan Web Security Scanner"
}

resource "aws_elastic_beanstalk_environment" "securescan_env" {
  name                = "${var.app_name}-env"
  application         = aws_elastic_beanstalk_application.securescan.name
solution_stack_name = "64bit Amazon Linux 2023 v4.12.1 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "securescan-jenkins"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    yum install java-17-amazon-corretto jenkins -y
    systemctl start jenkins
    systemctl enable jenkins
  EOF
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow Jenkins and SSH"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
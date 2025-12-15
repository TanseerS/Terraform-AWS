# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = var.app_name
  description = "Blue-Green Deployment Demo Application"

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# S3 Bucket for application versions
resource "aws_s3_bucket" "app_versions" {
  bucket = "${var.app_name}-versions-${random_string.suffix.result}"

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

resource "random_string" "suffix" {
  length  = 8
  lower   = true
  upper   = false
  numeric = true
  special = false
}

# Upload application versions to S3
resource "aws_s3_object" "app_v1" {
  bucket = aws_s3_bucket.app_versions.bucket
  key    = "app-v1.zip"
  source = "app-v1/app-v1.zip"
  etag   = filemd5("app-v1/app-v1.zip")
}

resource "aws_s3_object" "app_v2" {
  bucket = aws_s3_bucket.app_versions.bucket
  key    = "app-v2.zip"
  source = "app-v2/app-v2.zip"
  etag   = filemd5("app-v2/app-v2.zip")
}

# Elastic Beanstalk Application Versions
resource "aws_elastic_beanstalk_application_version" "v1" {
  name        = var.app_version_blue
  application = aws_elastic_beanstalk_application.app.name
  description = "Version 1.0 - Blue Environment"
  bucket      = aws_s3_bucket.app_versions.bucket
  key         = aws_s3_object.app_v1.key
}

resource "aws_elastic_beanstalk_application_version" "v2" {
  name        = var.app_version_green
  application = aws_elastic_beanstalk_application.app.name
  description = "Version 2.0 - Green Environment"
  bucket      = aws_s3_bucket.app_versions.bucket
  key         = aws_s3_object.app_v2.key
}

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "eb_service_role" {
  name = "${var.app_name}-eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eb_service" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# IAM Instance Profile
resource "aws_iam_role" "eb_ec2_role" {
  name = "${var.app_name}-eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eb_ec2" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "${var.app_name}-instance-profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Security Group for Elastic Beanstalk
resource "aws_security_group" "eb_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group for Elastic Beanstalk instances"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# Blue Environment
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "${var.app_name}-${var.environment_blue}"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Node.js 16"
  version_label       = aws_elastic_beanstalk_application_version.v1.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_sg.id
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instances
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instances
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Blue"
    ManagedBy   = "Terraform"
  }
}

# Green Environment
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "${var.app_name}-${var.environment_green}"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Node.js 16"
  version_label       = aws_elastic_beanstalk_application_version.v2.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_sg.id
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_instances
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_instances
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  tags = {
    Project     = "BlueGreenDeployment"
    Environment = "Green"
    ManagedBy   = "Terraform"
  }
}
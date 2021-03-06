variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_mount_cwd" {
  type = string
}

variable "env" {
  type    = string
  default = "local"
}

terraform {
  required_providers {
    aws = {
      version = "= 3.73.0"
    }
  }

  required_version = "= 1.1.4"
}

provider "aws" {
  access_key                  = "test_access_key"
  secret_key                  = "test_secret_key"
  region                      = var.aws_region
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway       = "http://localhost:4566"
    cloudformation   = "http://localhost:4566"
    cloudwatch       = "http://localhost:4566"
    cloudwatchevents = "http://localhost:4566"
    iam              = "http://localhost:4566"
    lambda           = "http://localhost:4566"
    s3               = "http://localhost:4566"
  }
}

resource "aws_iam_role" "lambda-execution-role" {
  name = "lambda-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test" {
  s3_bucket     = "__local__"
  s3_key        = var.lambda_mount_cwd
  function_name = "test-${var.env}"
  role          = aws_iam_role.lambda-execution-role.arn

  runtime = "go1.x"
  handler = "main"

  environment {
    variables = {
      ENV = var.env
    }
  }
}

output "lambda_arn" {
  value = aws_lambda_function.test.arn
}

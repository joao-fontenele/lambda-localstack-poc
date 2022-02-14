variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

//variable "JAR_PATH" {
//  type    = string
//  default = "build/libs/localstack-sampleproject-all.jar"
//}

variable "LAMBDA_MOUNT_CWD" {
  type    = string
}

variable "env" {
  type = string
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
  region                      = var.AWS_REGION
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

//resource "aws_lambda_function" "exampleFunctionOne" {
//  s3_bucket     = var.STAGE == "local" ? "__local__" : null
//  s3_key        = var.STAGE == "local" ? var.LAMBDA_MOUNT_CWD : null
////  filename      = var.STAGE == "local" ? null : var.JAR_PATH
//  function_name = "ExampleFunctionOne"
//  role          = aws_iam_role.lambda-execution-role.arn
//  handler       = "org.localstack.sampleproject.api.LambdaApi"
//  runtime       = "go1.x"
//  timeout       = 30
//  source_code_hash = filebase64sha256(var.JAR_PATH)
//  environment {
//    variables = {
//      FUNCTION_NAME = "functionOne"
//    }
//  }
//}

resource "aws_lambda_function" "fetcher" {
  s3_bucket     = "__local__"
  s3_key        = var.LAMBDA_MOUNT_CWD
  function_name = "secrets-api-fetcher-${var.env}"
  role          = aws_iam_role.lambda-execution-role.arn

  runtime = "go1.x"
  handler = "main"

  environment {
    variables = {
      ENV = var.env
    }
  }

//  vpc_config {
//    subnet_ids         = var.subnet_ids
//    security_group_ids = var.sg_ids
//  }
}

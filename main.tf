terraform {
  backend "s3" {
    bucket         = "baton-monitoring-infra-terraform-state"
    key            = "monitoring/ec2/state-change/{account-name}.tfstate"
    region         = "us-east-1"
    profile        = "{account-name}"
  }
}

#<------provider----->

provider "aws" {
  profile =var.provider_profile
  region    =var.provider_region
}

#<----- creating  topic -------->

resource "aws_sns_topic" "sns_topic" {
  name            = var.name
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  tags = { 
     "customer"=var.customer,
     "cost-center"=var.cost_center
  }   
}

#<------ creating aws_sns_topic_subscription ------->
 
resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

#<------creating  aws_cloudwatch_event_rule-------->

resource "aws_cloudwatch_event_rule" "rule" {
  name        = var.name
  description = "Capture each AWS EC2 Instance State Change"
  event_pattern = <<EOF
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "terminated",
      "shutting-down",
      "stopped"
    ]
  }
}
EOF
}

#<------- Add the aws_cloudwatch_event_target-------->

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "${aws_lambda_function.test_lambda.function_name}"
  arn       = "${aws_lambda_function.test_lambda.arn}"
}

#<-------Creating  lambda Function ------->

locals{
    lambda_zip_location = "output/lambda_function"

}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name =  var.name
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "lambda_function.lambda_handler"
  tags = { 
     "customer"=var.customer,
     "cost-center"=var.cost_center
  }  
   

#source_code_hash = filebase64sha256("output/lambda_function.zip")

  runtime = "python3.8"

  environment {
     variables = {
      sns_topic_arn = "${aws_sns_topic.sns_topic.arn}"
      tag_key = "${var.tag_key}"
      tag_value = "${var.tag_value}"
      
    }
    
  }
}

#<------creating aws_iam_role for Lambda Function ------->

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = "${file("iam/lambda_policy.json")}"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = "${file("iam/lambda_assume_policy.json")}"
}


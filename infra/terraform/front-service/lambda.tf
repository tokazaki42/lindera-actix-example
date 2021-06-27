locals {
 subnet_ids = ["subnet-0baf4bc02a1f50d0c"]
 security_group_ids = ["sg-08a4691b4cda2314c"]
  
}

resource "aws_lambda_function" "front_service" {
  function_name    = "lindera_caller_service"
  description      = ""
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  role             =  aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.front_service.output_path
  source_code_hash = data.archive_file.front_service.output_base64sha256
  timeout          = 60

  vpc_config {
    subnet_ids = local.subnet_ids
    security_group_ids = local.security_group_ids
  }

}

data "archive_file" "front_service" {
  type        = "zip"
  output_path = "./front_service.zip"
  source_dir  = "src/"
}

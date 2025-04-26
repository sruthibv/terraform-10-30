data "aws_iam_role" "lambda_existing_role" {
    name = "lambda-s3"
}

resource "aws_lambda_function" "lambda" {
  function_name = "test"
  handler = "lambda_function.lambda_handler"
  filename = "lambda.zip"
  role = data.aws_iam_role.lambda_existing_role.arn
  runtime = "python3.13"
  timeout = 300
}
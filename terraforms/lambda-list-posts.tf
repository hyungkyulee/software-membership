data "archive_file" "list_posts" {
  type        = "zip"
  source_dir  = "../src/list-posts"
  output_path = "../src/list-posts.zip"
}

resource "aws_lambda_function" "list_posts" {
  function_name = "${var.component}_${var.environment}_list_posts"
  filename      = data.archive_file.list_posts.output_path

  runtime = "nodejs14.x"
  handler = "listPosts.handler"

  source_code_hash = data.archive_file.list_posts.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
}

resource "aws_cloudwatch_log_group" "list_posts" {
  name = "/aws/lambda/${aws_lambda_function.list_posts.function_name}"

  retention_in_days = 30
}

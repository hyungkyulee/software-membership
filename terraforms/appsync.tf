resource "aws_appsync_graphql_api" "appsync" {
  name                = "${var.component}_${var.environment}_appsync"
  schema              = file("../schema.graphql")
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_key" "appsync_api_key" {
  api_id = aws_appsync_graphql_api.appsync.id
}

resource "aws_appsync_datasource" "list_posts" {
  name             = "${var.component}_${var.environment}_list_posts"
  api_id           = aws_appsync_graphql_api.appsync.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.list_posts.arn
  }
}

resource "aws_appsync_resolver" "list_posts_resolver" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "listPosts"
  data_source = aws_appsync_datasource.list_posts.name

  request_template  = file("../resolvers/request.vtl")
  response_template = file("../resolvers/response.vtl")
}

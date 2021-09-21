
resource "aws_security_group" "lambda_function_sg"{
  name = "${var.lambda_function_name}-sg"
  description = "${var.lambda_function_name}-sg"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "${var.lambda_function_name}-sg-ingress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]

      ipv6_cidr_blocks = null
      prefix_list_ids =  null
      security_groups = null
      self = null
    }
  ]

  egress = [
    {
      description      = "${var.lambda_function_name}-sg-egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]

      ipv6_cidr_blocks = null
      prefix_list_ids =  null
      security_groups = null
      self = null      
    }
  ]

  tags = var.tags
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_function_name}-policy"
  path        = "/"
  description = "IAM policy for lambda function ${var.lambda_function_name}"
  tags        = var.tags
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action":"*",
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role" "lambda_function_role" {
  name = "${var.lambda_function_name}"
  tags = var.tags
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

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  depends_on       = [aws_iam_role.lambda_function_role]
  function_name    = var.lambda_function_name
  runtime          = var.lambda_function_runtime
  handler          = var.lambda_handler_name
  role             = aws_iam_role.lambda_function_role.arn
  memory_size      = var.lambda_max_memory
  timeout          = var.lambda_timeout
  filename         = var.lambda_deployment_package_path  #"lambda_function_payload.zip"
  source_code_hash = filebase64sha256(var.lambda_deployment_package_path)

  tags             = var.tags
  vpc_config {
    security_group_ids = [aws_security_group.lambda_function_sg.id]
    subnet_ids         = var.subnet_ids
  }

  dynamic "environment" {
    for_each = length(var.lambda_env_variables) > 0 ? [true] : []

    content {
      variables = var.lambda_env_variables
    }
  }
  
}
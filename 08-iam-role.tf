resource "aws_iam_role_policy" "app_policy" {
  name = "${var.region}_${var.environment}_app-role"
  role = aws_iam_role.app.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [
          "arn:aws:secretsmanager:${var.region}:*:secret:${aws_secretsmanager_secret.password.name}-*",
          "arn:aws:secretsmanager:${var.region}:*:secret:${aws_secretsmanager_secret.db_hostname.name}-*"
        ]
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "app" {
  name = "${var.region}_${var.environment}_app-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# resource "aws_iam_role_policy_attachment" "app" {
#   policy_arn = aws_iam_policy.app.arn
#   role       = aws_iam_role.app.name
# }

resource "aws_iam_instance_profile" "app" {
  name = "${var.region}-${var.environment}-app-profile"
  role = aws_iam_role.app.name
}


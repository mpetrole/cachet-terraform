resource "aws_iam_user" "ses" {
  name = "cachet_ses_user"
  path = ""
}

resource "aws_iam_access_key" "ses" {
  user = aws_iam_user.ses.name
}

resource "aws_iam_user_policy" "cachet_ses" {
  name = "cachet-send-email"
  user = aws_iam_user.ses.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "arn:aws:ses:${var.ses_region}:${data.aws_caller_identity.current.account_id}:identity/*"
        }
    ]
}
EOF
}

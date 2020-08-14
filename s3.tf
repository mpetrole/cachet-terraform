resource "aws_s3_bucket" "status_logs" {
  bucket        = "cachet-alb-logs-${data.aws_caller_identity.current.account_id}"
  acl           = "log-delivery-write"
  force_destroy = true
  region        = data.aws_region.current.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "AWSConsole-AccessLogs-Policy-1564760075096",
  "Statement": [
      {
          "Sid": "AWSConsoleStmt-1564760075096",
          "Effect": "Allow",
          "Principal": {
              "AWS": "${local.elb_arn}"
          },
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::cachet-alb-logs-${data.aws_caller_identity.current.account_id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      },
      {
          "Sid": "AWSLogDeliveryWrite",
          "Effect": "Allow",
          "Principal": {
              "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::cachet-alb-logs-${data.aws_caller_identity.current.account_id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
          "Condition": {
              "StringEquals": {
                  "s3:x-amz-acl": "bucket-owner-full-control"
              }
          }
      },
      {
          "Sid": "AWSLogDeliveryAclCheck",
          "Effect": "Allow",
          "Principal": {
              "Service": "delivery.logs.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "arn:aws:s3:::cachet-alb-logs-${data.aws_caller_identity.current.account_id}"
      }
  ]
}
EOF
}

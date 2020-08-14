# get the region that terraform is working in
data "aws_region" "current" {}

# Get the aws elb account
data "aws_elb_service_account" "main" {}

# Get account information
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "main" {
  name         = var.zone
  private_zone = false
}

locals {
  elb_arn  = data.aws_elb_service_account.main.arn
  domain   = "${var.subdomain}.${var.zone}"
  userdata = <<EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras install docker
  service docker start
  usermod -a -G docker ec2-user
  sleep 10
  docker run -d --name cachet -p 8000:8000 -e DB_DRIVER=pgsql \
  -e DB_DATABASE=postgres -e DB_USERNAME=postgres -e DB_PASSWORD=${var.cachet_db_pass} -e DB_HOST=${aws_db_instance.cachet.address} \
  -e MAIL_DRIVER=ses -e MAIL_HOST=email-smtp.${var.ses_region}.amazonaws.com \
  -e MAIL_PORT=587 -e MAIL_USERNAME=${aws_iam_access_key.ses.id} -e MAIL_PASSWORD=${aws_iam_access_key.ses.secret} \
  -e MAIL_ADDRESS=${aws_ses_email_identity.cachet.email} -e SES_REGION=eu-central-1 -e APP_KEY=${var.app_key} -e APP_DEBUG=${var.debug} -d cachethq/docker:latest
EOF
}

# grab the latest amazon-linux2 ami
data "aws_ami" "amzn2-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989", "045324592363"] # Amazon - you can add additional owners here and Terraform will use the first one found (useful for alternate partitions)
}

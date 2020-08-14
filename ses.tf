resource "aws_ses_domain_identity" "domain" {
  domain = local.domain
}

resource "aws_ses_domain_mail_from" "domain" {
  domain           = aws_ses_domain_identity.domain.domain
  mail_from_domain = aws_ses_domain_identity.domain.domain
}

resource "aws_ses_email_identity" "cachet" {
  email = var.admin_email
}

resource "aws_route53_record" "cachet" {
  zone_id = var.zone
  name    = local.domain
  type    = "A"
  alias {
    name                   = aws_alb.cachet_lb.dns_name
    zone_id                = aws_alb.cachet_lb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "domain_amazonses_verification_record" {
  zone_id = var.zone
  name    = "_amazonses.${aws_ses_domain_identity.domain.id}"
  type    = "TXT"
  ttl     = "60"
  records = ["${aws_ses_domain_identity.domain.verification_token}"]
}

resource "aws_route53_record" "ses_domain_mail_from_mx" {
  zone_id = var.zone
  name    = aws_ses_domain_mail_from.domain.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${var.ses_region}.amazonses.com"]
}

resource "aws_route53_record" "ses_domain_spf" {
  zone_id = var.zone
  name    = aws_ses_domain_mail_from.domain.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cachet.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cachet.domain_validation_options.0.resource_record_type
  zone_id = var.zone
  records = ["${aws_acm_certificate.cachet.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

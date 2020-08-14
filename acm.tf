resource "aws_acm_certificate" "cachet" {
  domain_name       = local.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cachet" {
  certificate_arn         = aws_acm_certificate.cachet.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

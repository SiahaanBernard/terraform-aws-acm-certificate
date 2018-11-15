resource "aws_acm_certificate" "this" {
  domain_name       = "${var.domain_name}"
  validation_method = "${local.validation_method}"

  tags = {
    Name          = "${var.certificate_name}"
    ProductDomain = "${var.product_domain}"
    Environment   = "${var.environment}"
    Description   = "${var.description}"
    ManagedBy     = "Terraform"
  }
}

resource "aws_route53_record" "this" {
  name    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.this.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "dns_validation" {
  certificate_arn         = "${aws_acm_certificate.this.arn}"
  validation_record_fqdns = ["${aws_route53_record.this.fqdn}"]
}

resource "aws_acm_certificate_validation" "email_validation" {
  certificate_arn = "${aws_acm_certificate.this.arn}"
}

data "aws_route53_zone" "zone" {
  name         = "${var.hosted_zone_name}"
  private_zone = "${local.is_hosted_zone_private}"
}

resource "aws_route53_zone" "route53-hostedzone" {
  name = var.domain_name

  tags = {
    Name = "${var.project_name}-hostedzone-${var.environment}"
  }
}

# Create a record for the main domain pointing to the ALB
resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.route53-hostedzone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# # Create a record for the API subdomain
# resource "aws_route53_record" "api" {
#   zone_id = aws_route53_zone.route53-hostedzone.zone_id
#   name    = "api.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = aws_lb.main.dns_name
#     zone_id                = aws_lb.main.zone_id
#     evaluate_target_health = true
#   }
# }

# Create a record for the Metabase subdomain
resource "aws_route53_record" "metabase" {
  zone_id = aws_route53_zone.route53-hostedzone.zone_id
  name    = "bi.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

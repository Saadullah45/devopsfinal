# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value = aws_subnet.private.*.id
}

output "route53_nameservers" {
  description = "List of Route 53 nameservers to update in your domain registrar"
  value = aws_route53_zone.route53-hostedzone.name_servers
}
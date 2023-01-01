output "aws_instance_public_dns" {
  value = aws_lb.ngingx.dns_name
}

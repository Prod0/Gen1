output "elb_dns_name" {
  value = aws_lb.front_lb.dns_name
}

output "Networklb_dns_name" {
  value = aws_lb.db_lb.dns_name
}
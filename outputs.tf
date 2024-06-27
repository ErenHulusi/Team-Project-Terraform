output "elb_dns_name" {
  value = aws_elb.app_elb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "ec2_instance_public_ip" {
  value = aws_instance.app_server[*].public_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.app_server[*].public_dns
}

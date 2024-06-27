resource "aws_instance" "app_server" {
  count           = var.instance_count
  ami             = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type   = var.instance_type
  key_name        = var.ec2_key_pair
  security_groups = [aws_security_group.ec2.name]
  subnet_id       = element([aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id], count.index % 2)

  tags = {
    Name = "AppServer-${count.index}"
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("user_data.sh")
}

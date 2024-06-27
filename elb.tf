# elb.tf: Elastic Load Balancer.

resource "aws_elb" "app_elb" {
  name               = "app-elb"
  availability_zones = [aws_subnet.public_subnet1.availability_zone, aws_subnet.public_subnet2.availability_zone]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = aws_instance.app_server[*].id

  tags = {
    Name = "app-elb"
  }

  security_groups = [aws_security_group.lb.id]
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.eu-central-1.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = ["${aws_security_group.endpoint_sg.id}"]

  private_dns_enabled = true

  subnet_ids = var.private_subnets
}

resource "aws_security_group" "endpoint_sg" {
  name        = "endpoint_sg"
  description = "Allow connections to the endpoint."
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cachet_sg" {
  name        = "cachet_sg"
  description = "Allow connections via the load balancer."
  vpc_id      = var.vpc_id

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    self      = true
  }
}

resource "aws_security_group" "cachet_backend" {
  name        = "cachet_backend"
  description = "Allow all connections to instances from authorized IP ranges"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.personal_cidr_ranges
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cachet" {
  ami                         = data.aws_ami.amzn2-linux.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  associate_public_ip_address = true
  subnet_id                   = var.private_subnets[0]
  user_data                   = base64encode(local.userdata)
  vpc_security_group_ids      = ["${aws_security_group.cachet_sg.id}", "${aws_security_group.cachet_rds.id}", "${aws_security_group.endpoint_sg.id}", "${aws_security_group.cachet_backend.id}"]

  tags = {
    Name = "Cachet"
  }
}

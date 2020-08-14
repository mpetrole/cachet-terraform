resource "aws_alb" "cachet_lb" {
  name               = "cachet-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cachet_lb.id]
  subnets            = var.public_subnets

  access_logs {
    bucket  = aws_s3_bucket.status_logs.bucket
    enabled = true
  }
}

resource "aws_lb_target_group" "cachet_tg" {
  name     = "cachet-lb-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 2
    timeout             = 10
    path                = "/api/v1/ping"
    interval            = 30
    matcher             = "200"
    port                = 8000
  }
}

resource "aws_lb_target_group_attachment" "cachet" {
  target_group_arn = aws_lb_target_group.cachet_tg.arn
  target_id        = aws_instance.cachet.id
  port             = 8000
}

resource "aws_alb_listener" "cachet_http" {
  load_balancer_arn = aws_alb.cachet_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "cachet_https" {
  load_balancer_arn = aws_alb.cachet_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.cachet.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cachet_tg.arn
  }
}

resource "aws_security_group" "cachet_lb" {
  name        = "cachet-load-balancer-sg"
  description = "Allow traffic to Cachet load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

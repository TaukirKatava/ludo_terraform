resource "aws_security_group" "alb-sg" {
  vpc_id = var.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-alb-sg"
    "Terraform" = "Yes"
    "Mode" = "common"
    "ManagedBy" = "Yudiz"
  }
}

resource "aws_lb" "ludo-prod-alb" {
  name               = "ludo-prod-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public-subnet-1a-id, var.public-subnet-1b-id, var.public-subnet-1c-id]

  #enable_deletion_protection = true

  tags = {
    Name = "${var.project_name}-alb"
    "Terraform" = "Yes"
    "Mode" = "common"
    "ManagedBy" = "Yudiz"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ludo-prod-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.ludo-prod-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Content not found right now"
      status_code  = "500"
    }
  }
}

resource "aws_lb_listener_rule" "listener_rules" {
  for_each = var.tg_arn
  listener_arn = aws_lb_listener.https_listener.arn
  #priority     = (index(var.tg_arn, each.key)*1 ) #priority will automaticlly decided.

  action {
    type             = "forward"
    target_group_arn = each.value
  }

  condition {
    host_header {
      values = ["stag-${replace(each.key, "_", "-")}.devops.ravikyada.in"]
    }
  }
}
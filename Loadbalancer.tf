# LB for Production

resource "aws_lb" "Prod_LB" {
  name               = "For-ECS-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG_LB.id]
  subnets            = [aws_subnet.Prod_public_subnet1.id, aws_subnet.Prod_public_subnet2.id]
}


# Target group for LB

resource "aws_lb_target_group" "LB-TG" {
  name     = "TG-for-LB"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Prod_Vpc.id

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = 200
  }
}

# Listener Group (Temporary once test is complete move to port 443)

resource "aws_lb_listener" "Prod_HTTP_LG" {
  load_balancer_arn = aws_lb.Prod_LB.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LB-TG.arn
  }
}
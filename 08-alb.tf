resource "aws_lb" "alb" {
  name               = "workshop-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg_allow_ssh.id}", "${aws_security_group.sg_allow_web.id}"]
  subnets            = aws_subnet.pub-subnets[*].id


  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "workshop-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 5
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

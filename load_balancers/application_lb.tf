resource "aws_lb" "aalimsee_tf_alb" {
  name               = "aalimsee-tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aalimsee_tf_web_sg.id]
  subnets            = aws_subnet.aalimsee_tf_public[*].id

  tags = {
    Name = "aalimsee-tf-alb"
  }
}

resource "aws_lb_target_group" "aalimsee_tf_tg" { 
  name     = "aalimsee-tf-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aalimsee_tf_main.id

  tags = {
    Name = "aalimsee-tf-target-group"
  }
}

resource "aws_lb_listener" "aalimsee_tf_listener" { 
  load_balancer_arn = aws_lb.aalimsee_tf_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aalimsee_tf_tg.arn
  }
}

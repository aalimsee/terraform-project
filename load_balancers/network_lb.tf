resource "aws_lb" "aalimsee_tf_db_nlb" { 
  name               = "aalimsee-tf-db-nlb"
  internal           = true # Internal NLB for private communication
  load_balancer_type = "network"
  subnets            = aws_subnet.aalimsee_tf_private[*].id

  tags = {
    Name = "aalimsee-tf-db-nlb"
  }
}

resource "aws_lb_target_group" "aalimsee_tf_db_tg" { 
  name        = "aalimsee-tf-db-target-group"
  port        = 3306 # Database port (MySQL)
  protocol    = "TCP" # NLB uses TCP for DB traffic
  vpc_id      = aws_vpc.aalimsee_tf_main.id

  health_check {
    protocol            = "TCP" # Health check uses TCP
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "aalimsee-tf-db-tg"
  }
}

resource "aws_lb_listener" "aalimsee_tf_db_listener" { 
  load_balancer_arn = aws_lb.aalimsee_tf_db_nlb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aalimsee_tf_db_tg.arn
  }
}


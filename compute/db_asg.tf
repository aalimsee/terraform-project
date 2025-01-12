resource "aws_launch_template" "aalimsee_tf_db_asg_lt" { 
}

resource "aws_autoscaling_group" "aalimsee_tf_db_asg" { 
  name    = "aalimsee-tf-web-asg" # Add this line to define the ASG name
  
  launch_template {
    id      = aws_launch_template.aalimsee_tf_web_asg_lt.id
    version = "$Latest"
  }

  min_size            = 2 
  max_size            = 5
  desired_capacity    = 2
  vpc_zone_identifier = aws_subnet.aalimsee_tf_public[*].id

  target_group_arns = [
    aws_lb_target_group.aalimsee_tf_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "aalimsee-tf-web-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

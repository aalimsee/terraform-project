resource "aws_launch_template" "aalimsee_tf_db_asg_lt" { 
  name          = "aalimsee-tf-db-launch-template"
  image_id      = "ami-05576a079321f21f8" # Same as the web launch template
  instance_type = "t2.micro"
  key_name      = "aalimsee-keypair"
  vpc_security_group_ids = [
    aws_security_group.aalimsee_tf_db_sg.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "aalimsee-tf-db-asg-instance"
    }
  }
}

resource "aws_autoscaling_group" "aalimsee_tf_db_asg" { 
  name    = "aalimsee-tf-db-asg" # Add this line to define the ASG name
 
  launch_template {
    id      = aws_launch_template.aalimsee_tf_db_asg_lt.id
    version = "$Latest"
  }

  min_size             = 2   # Minimum number of DB instances
  max_size             = 5   # Maximum number of DB instances
  desired_capacity     = 2   # Desired number of DB instances
  vpc_zone_identifier  = aws_subnet.aalimsee_tf_private[*].id # Private subnets for database
  health_check_type    = "EC2"
  health_check_grace_period = 300

  target_group_arns = [
    aws_lb_target_group.aalimsee_tf_db_tg.arn
  ]

  tag {
      key                 = "Name"
      value               = "aalimsee-tf-db-asg"
      propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

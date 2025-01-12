resource "aws_launch_template" "aalimsee_tf_web_asg_lt" { 
  name          = "aalimsee-tf-web-launch-template"
  image_id      = "ami-05576a079321f21f8"
  instance_type = "t2.micro"
 
  metadata_options {
    http_tokens        = "optional"  # Allows both IMDSv1 and IMDSv2
    http_endpoint      = "enabled"   # Enables access to the metadata service
    http_put_response_hop_limit = 2   # Optional, sets the hop limit for metadata requests
  }
 
  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install httpd -y
echo "<h1>Hello from Application 1, Aaron Lim</h1>" | sudo tee /var/www/html/index.html
echo "<h1>Hello from Instance $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1>" | sudo tee -a /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
)

  key_name      = "aalimsee-keypair" # Updated here
  vpc_security_group_ids = [
    aws_security_group.aalimsee_tf_web_sg.id
  ]

  tags = {
    Name = "aalimsee-tf-launch-template"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aalimsee_tf_web_asg" { 
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

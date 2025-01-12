resource "aws_security_group" "aalimsee_tf_web_sg" { 
  name = "aalimsee-tf-web-sg"
  vpc_id = aws_vpc.aalimsee_tf_main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "aalimsee-tf-web-sg"
  }

resource "aws_security_group" "aalimsee_tf_db_sg" { 
  name = "aalimsee-tf-db-sg"
  vpc_id = aws_vpc.aalimsee_tf_main.id

  # Allow NLB to connect to DB on port 3306
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    security_groups   = [aws_security_group.aalimsee_tf_nlb_sg.id]
    description       = "Allow NLB to access DB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aalimsee-tf-db-sg"
  }
}

resource "aws_security_group" "aalimsee_tf_nlb_sg" { 
  name = "aalimsee-tf-nlb-sg"
  vpc_id = aws_vpc.aalimsee_tf_main.id

  # Allow inbound traffic from the web ASG to the NLB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic to NLB"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "aalimsee-tf-nlb-sg"
  }
}


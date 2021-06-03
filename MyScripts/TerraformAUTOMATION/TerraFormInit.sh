#!/bin/bash

### This is a test script made by VZlatkov (a.k.a Xerxes) that uses A.Alexiev's Terraform configs that would automate the deployment of AWS resources without the need to write any code but instead just input the variables that one would need for the deployment.
### v1.0.1
### I have no idea what the fuck I am going to do in this revision appart from pasting the JSON code and substituting the objects with variables.


###							THOSE ARE MY VARIABLES AND READ PROMPTS						###

echo '			THIS SCRIPT IS A SCRIPT FOR AUTOMATED DEPLOYMENT OF AWS RESOURCES USING TERRAFORM'
echo \n
echo -p "	PLEASE INSERT THE REGION YOU WANT TO USE \n" region
echo \n
echo -p "	PLEASE INSERT ACCESS KEY \n" ac
echo \n
echo -p "	PLEASE INSERT A SECRET KEY \n" sc
echo \n
echo -p "	PLEASE INSERT A VPC NAME \n" vpc
echo \n
echo -p "	PLEASE INSERT A GATEWAY \n" gw
echo \n
echo -p ""
###								THIS IS ALEXE'S CODE							###


###########################################################################################################################################
# This configuration will provision a vpc spanning 2 subnets in 2 AZs
# An ASG will be created in front of an application load balancer
# create s3 bucket
# create an IAM role for the instance
# in the user data, download the index file from the s3 bucket
# the name of the load balancer, and autoscaling group should be output by TF code when successfully deployed (output command)
# user variables and modules if possible
#in order to finally get it to work, i needed to change the egress policies for the autosclaing group to allow all comms on all ports
# because the aws cli uses ssh (i think) to communicate, so the instances needed to access the bucket in order to copy the file
###########################################################################################################################################

provider "aws" {
  region     = "$region"
  access_key = $ac
  secret_key = $sc
}

resource "aws_vpc" "vpc3" {
  cidr_block = "10.0.0.0/16"

  tags = {
  Name = "$vpc"
  }
}

### I will leave all the subnets hardcoded, just for redundancy's sake
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc3.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Subnet1 us-east-2a"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc3.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Subnet2 us-east-2b"
  }
}

###  Create Gateway
resource "aws_internet_gateway" "$gw" {
  vpc_id = aws_vpc.vpc3.id
}

### Create route table pointing both subnets to the gateway
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.$gw.id
  }

  tags = {
    Name = "Route Table for Subnets 1 & 2"
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}

echo \n
echo "			THIS IS THE SECURITY GROUPS INITIALIZATION PART"
echo \n
echo -p "INSERT INBOUND START PORT FOR THE ELB" elb_fp
echo -p "INSERT INBOUND END PORT FOR THE ELB" elb_tp	
echo -p "INSERT THE DESIRED PROTOCOL" protocol
echo -p "INSERT OUTBOUND START PORT FOR THE ELB" elb_fp_out
echo -p "INSERT OUTBOUND END PORT FOR THE ELB" elb_tp_out
### create security group for the load balancer
### allow http traffic to the instances only from the LB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow http traffic through the Application Load Balancer"
  vpc_id      = aws_vpc.vpc3.id

  ingress {
    from_port   = $elb_fp
    to_port     = $elb_tp
    protocol    = "$protocol"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = $elb_fp_out
    to_port     = $elb_tp_out
    protocol    = "$protocol"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow http traffic through the Application Load Balancer"
  }
}


### security group for ASG

resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "Allow http traffic from load balancer"
  vpc_id      = aws_vpc.vpc3.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]

    #    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    #    security_groups = [
    #     aws_security_group.elb_sg.id
    #    ]
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Allow http traffic from LB and ssh from the internet"
  }
}


### Create Application Load Balancer
### create listener(s)
### attach target group to ASG

resource "aws_lb" "test" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]

  enable_cross_zone_load_balancing = true

}

#create target group

resource "aws_lb_target_group" "tgtest" {
  name        = "test-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc3.id
  target_type = "instance"

  ## TEST  changing /index.html to /
  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
    path                = "/"
  }

}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgtest.arn
  }
}


### Create ASG launch Config (Apache webservers)
###  user data to dl file from s3
### link iam role/ instance policy

resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix   = "asg_launch-"
  image_id      = "ami-00399ec92321828f5" #ubuntu
  instance_type = "t2.micro"

  security_groups             = [aws_security_group.asg_sg.id]
  associate_public_ip_address = true

  ### TEST - link iam instance profile here? ask ###
  iam_instance_profile = aws_iam_instance_profile.test_profile.id


  lifecycle {
    create_before_destroy = true
  }


  user_data = <<-EOF
                #!/bin/bash
                sudo apt -y update
                sudo apt -y upgrade
                sudo apt install apache2 -y
                sudo systemctl enable apache2
                sudo systemctl start apache2
                sudo systemctl restart apache2
                sudo rm -f /var/www/html/*.html
                sudo apt -y install awscli
                sudo aws s3 cp s3://s3alekstestbucket/indexfile /var/www/html/index.html
                EOF

}


### create auto scaling group, reference launch config, set load balancer as health monitor

resource "aws_autoscaling_group" "asg" {
  name                      = "asg_test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  #  force_delete              = true
  launch_configuration = aws_launch_configuration.asg_launch_config.name #.name??
  vpc_zone_identifier  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  target_group_arns    = ["${aws_lb_target_group.tgtest.arn}"]
}



###create scaling threshold of 65% CPU
resource "aws_autoscaling_policy" "asg_cpu_threshold" {
  name                   = "asg-cpu-threshold-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 65.0
  }
}

### S3 bucket

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3alekstestbucket"
  acl    = "private"
  tags = {
    Name = "test_bucket"
  }
}

### upload index file to bucket

resource "aws_s3_bucket_object" "test_indexfile" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "indexfile"
  source = "./s3file/index.html"
}


### Create iam role for s3 access <->

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

##create aws_iam_role_policy

## under resource- the first ARN resource line specifies list bucket action- so the instances can list the objects in the bucket
## the second ARN resource line specifies the objects themselves, i.e., the ability to read write and delete the objects
## in this instance I could further specify "GetObject" under "Action" to only allow the ability to list and obtain the file

resource "aws_iam_role_policy" "access_policy" {
  name = "test_access_policy"
  role = aws_iam_role.s3_access_role.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "s3:*",
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.s3_access_role.id
}



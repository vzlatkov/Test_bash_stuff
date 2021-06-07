#!/bin/bash

### This is a test script made by VZlatkov (a.k.a Xerxes) that uses A.Alexiev's (https://github.com/apaleksiev/) Terraform configs that would automate the deployment of AWS resources without the need to write any code but instead just input the variables that one would need for the deployment.
### v1.0.1
### I have no idea what the fuck I am going to do in this revision appart from pasting the JSON code and substituting the objects' values with variables.
### v1.0.2
### The script is still full of bugs since most of the varibles are not escaped properly in the heredocs. However, the terraform file is creaed as intended (kind of...). 
### I have to make Terraform checker and installer, to hardcode an array of AMI's and instance types and provide the option to choose what to use for the launch configuration. 
### Plus, I have to make the script, allow you to choose which of the resources you want to use instead of creating all of them!
### v1.0.3
### This revision fixed most of the bugs and the script is now generating a fully working terraform file. The next revisions to be considered as a QOL improvements and DLC's.




###HERE WE DEFINE SOME GLOB VARIABLES TO MAKE OUR LIFES EASIER
# THOSE ARE THE VARIABLES FOR THE COLORS:
        GREEN="\e[32m"
        RED="\e[31m"
        ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

#echo the ">> insert here:"
st=`echo '>> insert here: '`




echo '                  THIS SCRIPT IS A SCRIPT FOR AUTOMATED DEPLOYMENT OF AWS RESOURCES USING TERRAFORM'
echo $cr
echo $cr
echo $cr
echo '############################################################################################################################'
echo '												CONNECT TO YOUR AWS ACCOUNT'
echo "					(please check the `$HOME`/.aws/configuration file for your access and secret keys)"
echo '############################################################################################################################'
echo $cr
read -p "       PLEASE INSERT THE REGION YOU WANT TO USE $cr $st" region
echo $st
echo $cr
read -p "       PLEASE INSERT ACCESS KEY $cr $st" ac
echo $st
echo $cr
read -p "       PLEASE INSERT A SECRET KEY $cr $st" sc
echo $st
echo $cr

#Break if mandatory arguments are not present

        if [ -z "$ac" ] || [ -z "$sc" ] || [ -z "$region" ];
        then
echo -e "                                   ${RED}WRONG/MISSING ARGUMENT(S). TRY AGAIN.${ENDCOLOR}"
sleep 2
echo $cr
echo $cr
echo $cr
		echo -ne '                                                                                                              (0 %)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
        echo -ne '\n'
        echo 'EXIT IN 3 SECONDS. THANK YOU FOR CHOOSING US TO TERRAFORM MARS AND YOUR CLOUD SOLUTIONS!'
        sleep 3
clear
                exit;
        else        
(
	cat > TERRAFORM.config <<EOF
provider "aws" {
  region     = "$region"
  access_key = "$ac"
  secret_key = "$sc"
}

EOF
)

echo 'done'
fi

###########This is the Networking Part ##########################

echo $cr
echo '############################################################################################################################'
echo '                        THIS IS THE VPC/NETWORK CONFIGURATION'
echo "          (please note that the VPC configuration is mandatory for AWS)"
echo '############################################################################################################################'
echo $cr
read -p "       PLEASE INSERT THE VPC NAME YOU WANT TO USE $cr $st" vpc_name
echo $st
echo $cr
read -p "       PLEASE INSERT Gateway $cr $st" gw
echo $st
echo $cr


#Break if mandatory arguments are not present

        if [ -z "$gw" ] || [ -z "$vpc_name" ];
        then
echo -e "                                   ${RED}WRONG/MISSING ARGUMENT(S). TRY AGAIN.${ENDCOLOR}"
sleep 2
echo $cr
echo $cr
echo $cr
    echo -ne '                                                                                                              (0 %)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
        echo -ne '\n'
        echo 'EXIT IN 3 SECONDS. THANK YOU FOR CHOOSING US TO TERRAFORM MARS AND YOUR CLOUD SOLUTIONS!'
        sleep 3
clear
                exit;
        else        

(
  cat >> TERRAFORM.config <<EOF
###Assign a VPC Name

resource "aws_vpc" "$vpc_name" {
  cidr_block = "10.0.0.0/16"

  tags = {
  Name = "$vpc_name"
  }
}

### I will leave all the subnets hardcoded, just for redundancy's sake
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.$vpc_name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Subnet1 us-east-2a"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.$vpc_name.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Subnet2 us-east-2b"
  }
}

###  Create Gateway
resource "aws_internet_gateway" "$gw" {
  vpc_id = aws_vpc.$vpc_name.id
}

### Create route table pointing both subnets to the gateway
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.$vpc_name.id

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

EOF
)

fi
###########This is the SG Part ##########################

echo $cr
echo '############################################################################################################################'
echo '                        THIS IS THE SECURITY GROUPS/FIREWALL CONFIGURATION'
echo "                  (please note that the VPC configuration is mandatory for AWS)"
echo '############################################################################################################################'
echo $cr
echo $cr
read -p "INSERT THE DESIRED NAME FOR THE LOAD BALANCER'S SG $cr $st" elb_sg
echo $st
echo $cr
read -p "INSERT THE DESIRED NAME FOR THE INSTANCES' SG $cr $st" asg_sg
echo $st
echo $cr
read -p "INSERT INBOUND START PORT FOR THE ELB $cr $st" elb_fp
echo $st
echo $cr
read -p "INSERT INBOUND END PORT FOR THE ELB $cr $st" elb_tp
echo $st
echo $cr
read -p "INSERT THE DESIRED PROTOCOL $cr $st" protocol
echo $st
echo $cr
read -p "INSERT OUTBOUND START PORT FOR THE ELB $cr $st" elb_fp_out
echo $st
echo $cr
read -p "INSERT OUTBOUND END PORT FOR THE ELB $cr $st" elb_tp_out
echo $st
echo $cr

(
  cat >> TERRAFORM.config <<EOF
### create security group for the load balancer
### allow http traffic to the instances only from the LB
resource "aws_security_group" "$elb_sg" {
  name        = "$elb_sg"
  description = "Allow http traffic through the Application Load Balancer"
  vpc_id      = aws_vpc.$vpc_name.id

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
EOF
)

###ASKS TO ADD THE SG FOR THE INSTANCES
echo $cr
echo "                  THIS IS THE SECURITY GROUP INITIALIZATION FOR THE INSTANCES"
echo $cr
read -p "INSERT INBOUND START PORT FOR THE EC2 $cr $st" ec2_fp
echo $cr
read -p "INSERT INBOUND END PORT FOR THE EC2 $cr $st" ec2_tp
echo $cr
read -p "INSERT THE DESIRED PROTOCOL $cr $st" protocol_ec2
echo $cr
echo $cr
###I AM LEAVING THE OUTBOUND RULES HARDCODED (ALL PORTS OPEN) FOR NOW
#read -p "INSERT OUTBOUND START PORT FOR THE EC2" ec2_fp_out
#read -p "INSERT OUTBOUND END PORT FOR THE EC2" ec2_tp_out

(
  cat >> TERRAFORM.config <<EOF
### security group for ASG

resource "aws_security_group" "$asg_sg" {
  name        = "$asg_sg"
  description = "Allow http traffic from load balancer"
  vpc_id      = aws_vpc.$vpc_name.id

  ingress {
    from_port   = $ec2_fp
    to_port     = $ec2_tp
    protocol    = "$protocol_ec2"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    #    security_groups = [
    #     aws_security_group.$elb_sg.id
    #    ]
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Allow http traffic from LB and ssh from the internet"
}
}

EOF
)


    ################################################################## ASG CONFIG STARTS FROM HERE #######################################################################


### Hardcode/declare variables for all the instances' types and AMI IDs in order to be able to choose from different ones and deploy different configurations running different OSes'.
### Use the package manager checking script that I made to create a reliable way to execute the userdata without the need to stick to a single distro.
### Add the option for the script to feed itself with userdata from your local machine or a URL with a script (ex.: VPS, S3 Bucket or /path/on/lockal/machine)



### Create ASG launch Config 
###  user data to dl file from s3
### link iam role/ instance policy









echo $cr
echo '############################################################################################################################'
echo '                        THIS IS THE ASG AND "LAUNCH CONFIG" CONFIGURATION'
#echo "                  (please note that the VPC configuration is mandatory for AWS)"
echo '############################################################################################################################'
echo $cr
echo $cr
read -p "INSERT THE DESIRED NAME FOR THE AUTOSCALING GROUP $cr $st" asg_test
echo $st
echo $cr
read -p "INSERT THE DESIRED CAPACITY FOR THE ASG $cr $st" cap
echo $st
echo $cr
read -p "INSERT THE MIN CAPACITY FOR THE ASG $cr $st" min
echo $st
echo $cr
read -p "INSERT THE MAX CAPACITY FOR THE ASG $cr $st" max
echo $st
echo $cr
read -p "INSERT PATH TO THE FILE FOR YOUR USERDATA $cr $st" userdata
echo $st
echo $cr




(
  cat >> TERRAFORM.config <<EOF

resource "aws_launch_configuration" "asg_launch_config" {
  name_prefix   = "asg_launch-"
  image_id      = "ami-00399ec92321828f5" #ubuntu ### This should be a variable . I have to hardcode (in an array) the possible options, so you can provision all types of AMI's
  instance_type = "t2.micro" #This should be a variable. I have to hardcode the instances available (in an array) and use them to allow the option to provision multiple instance types.

  security_groups             = [aws_security_group.$asg_sg.id]
  associate_public_ip_address = true

  ### TEST - link iam instance profile here? ask ###
  iam_instance_profile = aws_iam_instance_profile.test_profile.id


  lifecycle {
    create_before_destroy = true
  }


  user_data = <<-$userdata

}


### create auto scaling group, reference launch config, set load balancer as health monitor

resource "aws_autoscaling_group" "asg" {
  name                      = "$asg_test" #$asg_test is the name of the variable for the ASG name. Not yet assigned to the "read" command
  max_size                  = $max
  min_size                  = $min
  health_check_grace_period = 300
  health_check_type         = "ELB" # I should add health check options in future. For now we leave it to ELB
  desired_capacity          = $cap 
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

EOF
)

################################################ELB CONF STARTS HERE #############################################################
################################################ELB CONF STARTS HERE ##############################################################



### Create Application Load Balancer
### create listener(s)
### attach target group to ASG

echo $cr
echo '############################################################################################################################'
echo "                        THIS IS THE LOADBALANCER'S CONFIGURATION"
#echo "                  (please note that the VPC configuration is mandatory for AWS)"
echo '############################################################################################################################'
echo $cr
echo $cr
read -p "INSERT THE DESIRED NAME FOR THE LB TARGET GROUP $cr $st" testtg
echo $cr
echo $cr
read -p "INSERT THE DESIRED NAME FOR THE LB ITSELF $cr $st" LBname

(
  cat >> TERRAFORM.config <<GG

resource "aws_lb" "$LBname" {
  name               = "$LBname"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.$elb_sg.id]
  subnets = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]
  enable_cross_zone_load_balancing = true
}

#create target group

resource "aws_lb_target_group" "$testtg" {
  name        = "$testtg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.$vpc_name.id
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
  load_balancer_arn = aws_lb.$LBname.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.$testtg.arn
  }
}

GG
)


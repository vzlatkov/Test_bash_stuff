#!/bin/bash

###This is a test to check if I can add JSON files in functions, create an array of those functions and then call the functions and substitude the variables in them.


##############################################################################################################################################################################################################
#
#							THIS IS AN EXAMPLE/EXIBIT OF THE SCRIPT INSIDE OF THE SCRIPT, SO I DO NOT GET CONFUSED ( BECAUSE XZIBIT, THAT'S WHY!!! )
#
##############################################################################################################################################################################################################

### Define several "files" in here 

##############################################
#example:
#fn1 () {
#	cat >> /$HOME/testforVarArr.txt <<EOF
#"	This is a pseudo JSON1
#	{
#		This line is called: "$var1"
#		And this line is called: "$var2"
#} "
#EOF
#}
##############################################



### END OF THE fn's

###############################################################################################
##############################################
#example:
### create an array of functions
#fn1=JSON1pr
#fn2=JSON2pr
#declare -a arr
#
#arr=("fn1" "fn2")
##############################################




###END OF THE ARRAY DECLARATION

###############################################################################################

##############################################
#example:
### "For" loop for the prompts
#
#for i in "${arr[@]}"; do
#
#read -p "Do you want to use $i " yes
###PROMPT  here
#
#if [ $yes == y ]
#then
#arr1=(${#arr[@]} "$i")
#fi
#for x in "${arr1[@]}"; do
#
#	if [ $x == fn1 ]; then
#		read -p "add name for var1" var1
#		read -p "add name for var2" var2
#	
#	elif [ $x == fn2 ]; then	
#		read -p "add name for var3" var3
#		read -p "add name for var4" var4
#		fi
#done
#
#$x >> /$HOME/testforVarArr.txt
#done
##############################################
##############################################################################################################################################################################################################
#
#							END OF THE EXAMPLE!					END OF THE EXAMPLE!					END OF THE EXAMPLE!					END OF THE EXAMPLE!					END OF THE EXAMPLE!
#
##############################################################################################################################################################################################################



##### ACTUAL SCRIPT STARTS HERE:


 ###HERE WE DEFINE SOME GLOB VARIABLES AND PRETTY COLOURS SO WE MAKE OUR LIFES EASIER AND PROVIDE THE SCRIPT WITH SOME BLING!
# THOSE ARE THE VARIABLES FOR THE COLORS:
        GREEN="\e[32m"
        RED="\e[31m"
        ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

#echo the ">> insert here:"
st=`echo '>> insert here: '`


#This Checks for the OS's package manager 

#Declaring the most common package managers!
declare -a pkgs=("yum" "apt")

#For loop that checks which is the correct one
for i in "${pkgs[@]}"; do
	echo which $i 1> /dev/null
done

echo '......................................................'
#This is an "if" statement to determine the package manager

if [ $? -eq 0 ]
	then echo "The package in use is $i"
fi
echo '......................................................'

#The initialization starts from here

read -p "Would you like to update (y/n) $cr" update
	if [ $update == y ]
		then sudo $i -y update
	fi

read -p "Would you like to upgrade (y/n) $cr" upgrade
if [ $upgrade == y ]
	then sudo $i -y upgrade

fi

echo which terraform
	
if [ $? != 0 ]

then continue

elif [ $i == apt ]

then		snap install --edge terraform

else $i install -y terraform

fi

############################################ END OF BLING-BLING ###############################################

############################################ THE TRANSPORTERS (JSON Statements) ###############################################
### Define Jason Stathams here

VPC () {
cat >> tf.tf <<EOF
###Assign a VPC Name

resource "aws_vpc" "$vpc_name" {
  cidr_block = "10.0.0.0/16"

  tags = {
  Name = "$vpc_name"
  }
} 
EOF
}

SUBNETS () {
cat >> tf.tf <<EOF
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
EOF
}

GATEWAY () {
cat >> tf.tf <<EOF
###  Create Gateway
resource "aws_internet_gateway" "$gw" {
  vpc_id = aws_vpc.$vpc_name.id
}
EOF
}

ROUTETBL () {
cat >> tf.tf <<EOF
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
}

 SGELB () {
  cat >> tf.tf <<EOF
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
}

SGASG () {
  cat >> tf.tf <<EOF
}
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
}
 
LAUNCHCONF () {
  cat >> tf.tf <<EOF
}

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


  user_data = <<-EOF2

#!/bin/bash

###This is a script for automatization of the installation and configuration of a Salt Stack master server. By VZlatkov (a.k.a. Xerxes)
###v1.0.1
### In this version we are going to set the basic installation of the Salt-master by updating and upgrading the OS and installing the needed dependencies. Then we are going to install the master server itself.
###v1.0.2
###Fixed the issue where if the conf file exists, it skips and does not add the local IP in it.
###v1.0.3
###This revision adds the missing "!" to the ShaBang, which was causing my userdata to fail whole day :D :D :D 



###This is the initial dependency installation part of the script
apt -y update
apt -y upgrade
apt -y install python3
apt -y install python3-pip
pip install salt #You first install the Salt Stack, then you configure it as a Master or Slave
# Download key
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
# Create apt sources list file
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list
apt-get update
apt-get -y install salt-master

###Get the local IP and create a variable
IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1) #Assigns the local IP addr of the machine to a variable so we can use it

###Start the service
systemctl daemon-reload
systemctl start salt-master
systemctl restart salt-master


###     Tests if the conf file/dir exists   ###

if [ -d /etc/salt/master ]; #Checks if the dir exists
        then 
        echo "interface: $IP" >> /etc/salt/master #Adds the local IP addr of the master in the confi file 

#continue #If exists - skips the "elif/else" statement
        else #If it doesn't exist - creates the path and file
                mkdir /etc/salt/

        (
cat > /etc/salt/master <<EOF3
interface: $IP
EOF3
)

fi

###Create a Salt-key
salt-key -F master

###Restart the service
systemctl daemon-reload
systemctl restart salt-master
systemctl status salt-master
  

EOF2
}
EOF
}

ASG () {
cat >> tf.tf <<EOF
### create auto scaling group, reference launch config, set load balancer as health monitor

resource "aws_autoscaling_group" "asg" {
  name                      = "$asg_test"
  max_size                  = $max
  min_size                  = $min
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = $cap 
  #  force_delete              = true
  launch_configuration = aws_launch_configuration.asg_launch_config.name #.name??
  vpc_zone_identifier  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  target_group_arns    = ["${aws_lb_target_group.tgtest.arn}"]
}
EOF
}

MONITORSCALE () {
cat >> tf.tf <<EOF
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
EOF
}

S3B () {
cat >> tf.tf <<EOF
### S3 bucket

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3alekstestbucket"
  acl    = "private"
  tags = {
    Name = "test_bucket"
  }
}
EOF
}

INDEXS3B () {
cat >> tf.tf <<EOF
### upload index file to bucket

resource "aws_s3_bucket_object" "test_indexfile" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "indexfile"
  source = "./s3file/index.html"
}

EOF
}

ELB () {
cat >> tf.tf <<GG

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
}



###################################################################################


#TEST INIT SCRIPT
#initscript () {
#cat >> tf.tf <<EOF2
#!/bin/bash

###This is a script for automatization of the installation and configuration of a Salt Stack master server. By VZlatkov (a.k.a. Xerxes)
###v1.0.1
### In this version we are going to set the basic installation of the Salt-master by updating and upgrading the OS and installing the needed dependencies. Then we are going to install the master server itself.
###v1.0.2
###Fixed the issue where if the conf file exists, it skips and does not add the local IP in it.
###v1.0.3
###This revision adds the missing "!" to the ShaBang, which was causing my userdata to fail whole day :D :D :D 



###This is the initial dependency installation part of the script
#apt -y update
#apt -y upgrade
#apt -y install python3
#apt -y install python3-pip
#pip install salt #You first install the Salt Stack, then you configure it as a Master or Slave
# Download key
#curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
# Create apt sources list file
#echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list
#apt-get update
#apt-get -y install salt-master

###Get the local IP and create a variable
#IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1) #Assigns the local IP addr of the machine to a variable so we can use it

###Start the service
#systemctl daemon-reload
#systemctl start salt-master
#systemctl restart salt-master


###     Tests if the conf file/dir exists   ###

#if [ -d /etc/salt/master ]; #Checks if the dir exists
#        then 
#        echo "interface: $IP" >> /etc/salt/master #Adds the local IP addr of the master in the confi file 

#continue #If exists - skips the "elif/else" statement
#        else #If it doesn't exist - creates the path and file
 #               mkdir /etc/salt/

#        (
#cat > /etc/salt/master<<EOF
#interface: $IP
#EOF
#)

#fi

###Create a Salt-key
#salt-key -F master

###Restart the service
#systemctl daemon-reload
#systemctl restart salt-master
#systemctl status salt-master

#EOF2
#}

##############################################################################################################################################################################################
#
#					END OF JASON STATHAMS 					END OF JSON STATEMENTS 					END OF JASON STATHAMS 					END OF JSON STATEMENTS
#
##############################################################################################################################################################################################


##### DECLARE AN ARRAY OF THE STATEMENTS
declare -a arr
arr=("VPC" "SUBNETS" "GATEWAY" "ROUTETBL" "SGELB" "LAUNCHCONF" "ASG" "SGASG" "S3B" "MONITORSCALE" "INDEXS3B" "ELB")



echo -e "${GREEN}############################################################################################################################${ENDCOLOR}"
echo -e "${RED}############################################################################################################################${ENDCOLOR}"
echo ""
echo "                  THIS SCRIPT IS A SCRIPT FOR AUTOMATED DEPLOYMENT OF AWS RESOURCES USING TERRAFORM"
echo ""
echo -e "${RED}############################################################################################################################${ENDCOLOR}"
echo -e "${GREEN}############################################################################################################################${ENDCOLOR}"
echo $cr
echo $cr
echo $cr

### "For" loop for the prompts
for i in "${arr[@]}"; do

###PROMPT  here
echo -e "##### ${GREEN} THIS IS THE CONFIG FOR $i ${ENDCOLOR} #####"
read -p "Do you want to use $i $cr $st" yes


if [ $yes == y ]
then
arr1=(${#arr[@]} "$i")
fi
for x in "${arr1[@]}"; do

	if [ $x == VPC ]; then
		read -p "add name for the VPC's name $cr $st" vpc_name
		
		elif [ $x == GATEWAY ]; then	
		read -p "add name for the Gateway $cr $st" gw
		
		elif [ $x == SGELB ]; then	
		read -p "add name for the ELB's security group $cr $st" elb_sg
		read -p "choose INCOMING STARTING port $cr $st" elb_fp
		read -p "choose INCOMING END port $cr $st" elb_tp
		read -p "choose protocol for the ELB $cr $st" protocol
		read -p "choose OUTGOING STARTING port $cr $st" elb_fp_out
		read -p "choose OUTGOING END port $cr $st" elb_tp_out

		elif [ $x == SGASG ]; then	
		read -p "add name for the ASG's security group $cr $st" asg_sg
		read -p "choose INCOMING STARTING port for the EC2 instances" ec2_fp
		read -p "choose INCOMING END port for the EC2 instances" ec2_tp
		read -p "choose protocol for the EC2 instances$cr $st" protocol_ec2
		
		elif [ $x == ASG ]; then	
		read -p "add name for the ASG $cr $st" asg_test
		read -p "select minimum number of instances $cr $st" min
		read -p "select desired number of instances $cr $st" cap
		read -p "select maximum number of instances $cr $st" max

		elif [ $x == ELB ]; then	
		read -p "add name for the ELB $cr $st" LBname
		read -p "add name for the ELB's target group $cr $st" testtg

			
		fi
done

$x >> /$PWD/tf.tf
done

terraform plan